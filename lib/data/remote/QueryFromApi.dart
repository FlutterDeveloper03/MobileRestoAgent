import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_resto_agent/Helpers/Exception.dart';
import 'package:mobile_resto_agent/model/CartItem.dart';
import 'package:mobile_resto_agent/model/customFichLine.dart';
import 'package:mobile_resto_agent/model/customOrderFich.dart';
import 'package:mobile_resto_agent/model/imageModel.dart';
import 'package:mobile_resto_agent/model/table.dart' as tbl;
import 'package:mobile_resto_agent/model/tbl_dk_device.dart';
import 'package:mobile_resto_agent/model/tbl_dk_table_category.dart';
import 'package:mobile_resto_agent/model/tbl_mg_category.dart';
import 'package:mobile_resto_agent/model/tbl_mg_mat_attributes.dart';
import 'package:mobile_resto_agent/model/tbl_mg_materials.dart';
import 'package:mobile_resto_agent/model/tbl_mg_order_fich.dart';
import 'package:mobile_resto_agent/model/tbl_mg_salesman.dart';
import 'package:sql_conn/sql_conn.dart';

class QueryFromApi {
  final String baseUrl;
  final int dbConnectionSettings;
  final String serverPort;
  final String dbUName;
  final String dbUPass;
  final String dbName;
  final String serverAddress;
  final String basePath = '/api/v1/make-db-request';
  final String cud = 'executeOnly';

  QueryFromApi(this.baseUrl, this.dbConnectionSettings,
      {this.serverAddress = "", this.dbName = "", this.serverPort = "", this.dbUName = "", this.dbUPass = ""});

  Future<int> connect() async {
    try {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        await SqlConn.connect(ip: serverAddress, port: serverPort, databaseName: dbName, username: dbUName, password: dbUPass);
        if (SqlConn.isConnected) {
          debugPrint("Connected!");
          return 1;
        } else {
          debugPrint("Can't connect to db.");
          return 0;
        }
      } else {
        debugPrint("Can't connect to db. Some required fields are empty");
        return 0;
      }
    } catch (e) {
      debugPrint("PrintError on QueryFromDb.connect: " + e.toString());
      return 0;
    }
  }

  static Future<TblDkDevice> getDeviceDetails() async {
    String? deviceName = '';
    String? deviceVersion = '';
    String? identifier = '';
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.baseOS ?? '';
        identifier = await const AndroidId().getId() ?? ''; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

    return TblDkDevice.fromMap({'DevUniqueId': identifier, 'DevName': deviceName, 'DevDesc': deviceVersion});
  }

  Future<String> getFirm() async {
    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.readData("SELECT firm_id_guid FROM tbl_mg_firm");
            if (result != null) {
              List decodedList = jsonDecode(result.toString());
              return decodedList.first['firm_id_guid'];
            }
          }
        } catch (e) {
          debugPrint("PrintError on QueryFromApi.getFirm: ${e.toString()}");
        }
      }
    } else {
      debugPrint("QueryFromApi.getFirm 7");
      Uri uri = Uri.http(baseUrl, basePath);
      try {
        var response = await http.post(
          uri,
          body: jsonEncode(<String, dynamic>{
            "query_string": """
        SELECT firm_id_guid FROM tbl_mg_firm
        """,
            "base64_columns": [],
          }),
        );
        if (response.statusCode == 200) {
          dynamic decoded = jsonDecode(response.body);
          List list = decoded['data'];
          if (list.isNotEmpty) {
            return list.first['firm_id_guid'];
          }
        }
      } catch (e) {
        print('Error on QueryFromApi.getFirm: ' + e.toString());
      }
    }
    return '';
  }

  Future<String> getFirmName() async {
    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.readData("SELECT firm_name FROM tbl_mg_firm");
            if (result != null) {
              List decodedList = jsonDecode(result.toString());
              return decodedList.first['firm_name'];
            }
          }
        } catch (e) {
          debugPrint("Error on QueryFromApi.getFirmName: ${e.toString()}");
        }
      }
    } else {
      Uri uri = Uri.http(baseUrl, basePath);
      var response = await http.post(
        uri,
        body: jsonEncode(<String, dynamic>{
          "query_string": """
        SELECT firm_name FROM tbl_mg_firm
        """,
          "base64_columns": [],
        }),
      );
      if (response.statusCode == 200) {
        dynamic decoded = jsonDecode(response.body);
        List list = decoded['data'];
        if (list.isNotEmpty) {
          return list.first['firm_name'];
        }
      }
    }

    return '';
  }

  Future<List<TblDkDevice>> getDevices() async {
    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.readData("SELECT * FROM tbl_dk_device");
            if (result != null) {
              List decodedList = jsonDecode(result.toString());
              if (decodedList.isEmpty) {
                throw DeviceNotFounException();
              }
              return decodedList.map((e) => TblDkDevice.fromCryptMap(e)).toList();
            }
          }
        } on PlatformException catch (e) {
          if (e.message == "Invalid object name 'tbl_dk_device'.") {
            throw TableNotFounException();
          }
        } catch (e) {
          debugPrint("Error on QueryFromApi.getDevices: ${e.toString()}");
        }
      }
    } else {
      Uri uri = Uri.http(baseUrl, basePath);
      var response = await http.post(
        uri,
        body: jsonEncode(<String, dynamic>{
          "query_string": """
          SELECT * FROM tbl_dk_device
        """,
          "base64_columns": [],
        }),
      );
      if (response.statusCode == 200) {
        dynamic decoded = jsonDecode(response.body);
        List list = decoded['data'];
        return list.map((e) => TblDkDevice.fromCryptMap(e)).toList();
      } else if (response.statusCode == 500 && jsonDecode(response.body)['message'] == "mssql: Invalid object name 'tbl_dk_device'.") {
        throw TableNotFounException();
      } else if (response.statusCode == 500 && jsonDecode(response.body)['message'] == "empty response") {
        throw DeviceNotFounException();
      }
    }

    return [];
  }

  Future<bool> updateDeviceTable(List<TblDkDevice> devices) async {
    String value = devices.map((e) {
      final enc.Key key1 = enc.Key.fromBase64(base64Encode('Xzd0Rda!B^VkQ5)jlJUD1*0aoTd-4*)2'.codeUnits));
      final iv = enc.IV.fromLength(16);
      final enc.Encrypter encrypter = enc.Encrypter(enc.AES(key1));
      return """
        UPDATE tbL_dk_device SET
        IsAllowed=${e.isAllowed ? 1 : 0},
        DevVerifyDate='${e.devVerifyDate.toString()}',
        DevVerifyKey='${(e.isAllowed) ? encrypter.encrypt(jsonEncode([e.isAllowed.toString(), e.devVerifyDate.toString()]), iv: iv).base64 : ''}',
        AddInf1='${e.addInf1}',
        AddInf2='${e.addInf2}',
        AddInf3='${e.addInf3}',
        AddInf4='${e.addInf4}',
        AddInf5='${e.addInf5}',
        AddInf6='${e.addInf6}',
        AddInf7='${e.addInf7}',
        AddInf8='${e.addInf8}',
        AddInf9='${e.addInf9}',
        AddInf10='${e.addInf10}',
        SyncDateTime= convert(datetime, '${e.syncDateTime}'),
        OptimisticLockField=${e.optimisticLockField},
        GCRecord=${e.gCRecord},
        ResPriceGroupId=${e.resPriceGroupId},
        UId=${e.uId}
        ${e.allowDate != null ? ", AllowDate= convert(datetime, '${e.allowDate}')" : ""}
        ${e.disallowedDate != null ? ",DisallowedDate=convert(datetime, '${e.disallowedDate} ')" : ""}
        WHERE DevUniqueId='${e.devUniqueId}'
      """;
    }).join(';');

    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.writeData(value);
            if (result != null) {
              return true;
            }
          }
        } catch (e) {
          debugPrint("Error on QueryFromApi.updateDeviceTable: ${e.toString()}");
        }
      }
    } else {
      Uri uriCreate = Uri.http(baseUrl, basePath, {cud: '1'});

      var response = await http.post(
        uriCreate,
        body: jsonEncode(<String, dynamic>{
          "query_string": """
            $value
        """,
          "base64_columns": [],
        }),
      );
      if (response.statusCode == 200) {
        return true;
      }
    }
    return false;
  }

  Future<bool> createDeviceTable() async {
    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.writeData("""
            CREATE TABLE tbl_dk_device (
              DevId INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
              DevGuid NVARCHAR(100) DEFAULT NEWID(),
              DevUniqueId NVARCHAR(100),
              RpAccId INTEGER,
              DevName NVARCHAR(200) NOT NULL,
              DevDesc NVARCHAR(500),
              IsAllowed BIT DEFAULT 0,
              DevVerifyDate DATETIME,
              DevVerifyKey NVARCHAR(MAX),
              AddInf1 NVARCHAR(500) DEFAULT '',
              AddInf2 NVARCHAR(500) DEFAULT '',
              AddInf3 NVARCHAR(500) DEFAULT '',
              AddInf4 NVARCHAR(500) DEFAULT '',
              AddInf5 NVARCHAR(500) DEFAULT '',
              AddInf6 NVARCHAR(500) DEFAULT '',
              AddInf7 NVARCHAR(500) DEFAULT '',
              AddInf8 NVARCHAR(500) DEFAULT '',
              AddInf9 NVARCHAR(500) DEFAULT '',
              AddInf10 NVARCHAR(500) DEFAULT '',
              CreatedDate DATETIME DEFAULT convert(datetime, GETDATE(), 104),
              ModifiedDate DATETIME DEFAULT convert(datetime, GETDATE(), 104),
              CreatedUId INTEGER DEFAULT 0,
              ModifiedUId INTEGER DEFAULT 0,
              SyncDateTime DATETIME,
              OptimisticLockField INTEGER,
              GCRecord INTEGER,
              ResPriceGroupId INTEGER,
              UId INTEGER,
              AllowDate DATETIME,
              DisallowedDate DATETIME
            );
            """);
            if (result != null) {
              return true;
            }
          }
        } catch (e) {
          debugPrint("PrintError on QueryFromApi createDeviceTable.: ${e.toString()}");
        }
      }
    } else {
      Uri uriCreate = Uri.http(baseUrl, basePath, {cud: '1'});
      var response = await http.post(
        uriCreate,
        body: jsonEncode(<String, dynamic>{
          "query_string": """
        CREATE TABLE tbl_dk_device (
          DevId INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
          DevGuid NVARCHAR(100) DEFAULT NEWID(),
          DevUniqueId NVARCHAR(100),
          RpAccId INTEGER,
          DevName NVARCHAR(200) NOT NULL,
          DevDesc NVARCHAR(500),
          IsAllowed BIT DEFAULT 0,
          DevVerifyDate DATETIME DEFAULT convert(datetime, GETDATE(), 104),
          DevVerifyKey NVARCHAR(MAX),
          AddInf1 NVARCHAR(500) DEFAULT '',
          AddInf2 NVARCHAR(500) DEFAULT '',
          AddInf3 NVARCHAR(500) DEFAULT '',
          AddInf4 NVARCHAR(500) DEFAULT '',
          AddInf5 NVARCHAR(500) DEFAULT '',
          AddInf6 NVARCHAR(500) DEFAULT '',
          CreatedDate DATETIME DEFAULT convert(datetime, GETDATE(), 104),
          ModifiedDate DATETIME DEFAULT convert(datetime, GETDATE(), 104),
          CreatedUId INTEGER DEFAULT 0,
          ModifiedUId INTEGER DEFAULT 0,
          SyncDateTime DATETIME,
          OptimisticLockField INTEGER,
          GCRecord INTEGER,
          ResPriceGroupId INTEGER,
          UId INTEGER,
          AllowDate DATETIME,
          DisallowedDate DATETIME
        );
        """,
          "base64_columns": [],
        }),
      );
      if (response.statusCode == 200) {
        return true;
      }
    }
    return false;
  }

  Future insertDevice() async {
    TblDkDevice device = await getDeviceDetails();
    String query = """
    INSERT INTO tbl_dk_device (
          DevUniqueId,
          RpAccId,
          DevName,
          DevDesc,
          IsAllowed,
          DevVerifyDate,
          DevVerifyKey,
          AddInf1,
          AddInf2,
          AddInf3,
          AddInf4,
          AddInf5,
          AddInf6,
          SyncDateTime,
          OptimisticLockField,
          GCRecord,
          ResPriceGroupId,
          UId,
          AllowDate,
          DisallowedDate
        ) VALUES (
          '${device.devUniqueId}',
          0,
          '${device.devName}',
          '${device.devDesc}',
          0,
          GETDATE(),
          '${device.devVerifyKey}',
          '',
          '',
          '',
          '',
          '',
          '',
          NULL,
          NULL,
          NULL,
          NULL,
          NULL,
          NULL,
          NULL
        )
    """;

    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.writeData(query);
            if (result != null) {
              return true;
            }
          }
        } catch (e) {
          debugPrint("Error on QueryFromApi.insertDevice: ${e.toString()}");
        }
      }
    } else {
      Uri uriCreate = Uri.http(baseUrl, basePath, {cud: '1'});
      var response = await http.post(
        uriCreate,
        body: jsonEncode(<String, dynamic>{
          "query_string": query,
          "base64_columns": [],
        }),
      );
      if (response.statusCode == 200) {
        print('Successfully inserted device!');
      } else {
        print('Error on inserting device:${response.body}! status:${response.statusCode}');
      }
    }
    return false;
  }

  Future<TblMgSalesman?> loginUser(String name, String password) async {
    String query = "select * from tbl_mg_salesman where salesman_pass='$password' and salesman_name='$name'";
    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.readData(query);
            if (result != null) {
              List decoded = jsonDecode(result);
              if (decoded.length > 0) {
                return TblMgSalesman.fromMap(decoded[0]);
              } else {
                throw UserNotFounException();
              }
            }
          }
        } catch (e) {
          debugPrint("PrintError on QueryFromApi.loginUser: ${e.toString()}");
        }
      }
    } else {
      Uri uri = Uri.http(baseUrl, basePath);
      var response = await http.post(
        uri,
        body: jsonEncode(<String, dynamic>{
          "query_string": query,
          "base64_columns": [],
        }),
      );
      if (response.statusCode == 200) {
        String source = Utf8Decoder().convert(response.bodyBytes);
        dynamic decoded = jsonDecode(source);
        List list = decoded['data'];
        if (list.length > 0) {
          return TblMgSalesman.fromMap(decoded['data'][0]);
        } else {
          throw UserNotFounException();
        }
      } else {
        throw UserNotFounException();
      }
    }
    return null;
  }

  Future<bool> moveTable(tbl.Table fromTable, tbl.Table toTable) async {
    String query = """
          DECLARE @toArapId INT = ${toTable.arapId}
          DECLARE @fromFichId INT = ${fromTable.fichId}
          DECLARE @fichId INT
          
          DECLARE @fichTotal DECIMAL(18,5)
          DECLARE @fichNetTotal DECIMAL(18,5)
          DECLARE @fichDiscount DECIMAL(18,5);
          
          
          WITH CTE AS (
              select ROW_NUMBER() OVER(partition by arap_id order by fich_date desc) as rn, fich_id, fich_code, arap_id, fich_date,fich_nettotal, fich_total from tbl_mg_order_fich
              where inv_id=0
          ) 
          select @fichId = fich_id from CTE
          right outer join tbl_mg_sale_disc_cards d on d.arap_id=cte.arap_id
          where (rn is null OR rn=1) and LEN(sale_disc_card_name)>0 and sale_disc_type_id=2 and d.arap_id=@toArapId
          
          if (@fichId is not null)
          BEGIN
            update tbl_mg_order_fich_line
            set fich_id=@fichId
            where fich_id=@fromFichId
          
            SELECT @fichTotal=SUM(fich_line_total),@fichNetTotal=SUM(fich_line_nettotal),@fichDiscount=SUM(fich_line_disc_amount) from tbl_mg_order_fich_line
            where fich_id=@fichId
          
            update tbl_mg_order_fich
            set fich_total=@fichTotal,fich_discount=@fichDiscount,fich_nettotal=@fichNetTotal
            where fich_id=@fichId
          
            DELETE FROM tbl_mg_order_fich
            where fich_id=@fromFichId
          
          END
          ELSE
          BEGIN
            update tbl_mg_order_fich
            set arap_id=@toArapId
            where fich_id=@fromFichId
          END
        """;
    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.writeData(query);
            if (result != null) {
              return true;
            }
          }
        } catch (e) {
          debugPrint("Error on QueryFromApi.moveTable: ${e.toString()}");
        }
      }
    } else {
      Uri uri = Uri.http(baseUrl, basePath);
      var response = await http.post(
        uri,
        body: jsonEncode(<String, dynamic>{
          "query_string": query,
          "base64_columns": [],
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  Future<List<tbl.Table>> getTables(String tableCategory) async {
    String query = """
        WITH CTE AS (
          select ROW_NUMBER() OVER(partition by arap_id order by fich_date desc) as rn, fich_id,spe_code,group_code,security_code,fich_desc, fich_code, arap_id, fich_date,fich_nettotal, fich_total,salesman_id from tbl_mg_order_fich f
          where inv_id=0
        ) 
        select d.arap_id, fich_id, fich_code, sale_disc_card_name, fich_total, fich_nettotal, fich_date, d.group_code,cte.spe_code,cte.group_code as f_group_code,cte.security_code,cte.fich_desc, CTE.salesman_id, s.salesman_name from CTE
        left outer join tbl_mg_salesman s on s.salesman_id=CTE.salesman_id
        right outer join tbl_mg_sale_disc_cards d on d.arap_id=cte.arap_id
        where (rn is null OR rn=1) and LEN(sale_disc_card_name)>0 and sale_disc_type_id=2 ${(tableCategory.isNotEmpty) ? ' and d.group_code like N\'$tableCategory\'' : ''}
        """;
    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.readData(query);
            if (result != null) {
              List decoded = jsonDecode(result);
              return decoded.map((e) => tbl.Table.fromMap(e)).toList();
            }
          }
        } catch (e) {
          debugPrint("Error on QueryFromApi.getTables: ${e.toString()}");
        }
      }
    } else {
      Uri uri = Uri.http(baseUrl, basePath);
      var response = await http.post(
        uri,
        body: jsonEncode(<String, dynamic>{
          "query_string": query,
          "base64_columns": [],
        }),
      );
      if (response.statusCode == 200) {
        String source = Utf8Decoder().convert(response.bodyBytes);
        dynamic decoded = jsonDecode(source);
        List list = decoded['data'];

        List<tbl.Table> tables = list.map((e) => tbl.Table.fromMap(e)).toList();

        return tables;
      }
    }
    return [];
  }

  Future<List<TblMgSalesman>> getSalesmans() async {
    String query =  '''
                      select * from tbl_mg_salesman
                    ''';
    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.readData(query);
            if (result != null) {
              List decoded = jsonDecode(result);
              return decoded.map((e) => TblMgSalesman.fromMap(e)).toList();
            }
          }
        } catch (e) {
          debugPrint("Error on QueryFromApi.getSalesmans: ${e.toString()}");
        }
      }
    }
    return [];
  }

  Future<List<TblDkTableCategory>> getTableCategories() async {
    String query = '''select sale_disc_card_id,group_code from (
                   select ROW_NUMBER() over (partition by group_code order by group_code) as rownum,sale_disc_card_id, group_code 
                   from tbl_mg_sale_disc_cards
                   where sale_disc_type_id=2) m
                   where m.rownum=1''';
    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.readData(query);
            if (result != null) {
              List decoded = jsonDecode(result);
              return decoded.map((e) => TblDkTableCategory.fromMap(e)).toList();
            }
          }
        } catch (e) {
          debugPrint("Error on QueryFromApi.getTableCategories: ${e.toString()}");
        }
      }
    } else {
      Uri uri = Uri.http(baseUrl, basePath);
      var response = await http.post(
        uri,
        body: jsonEncode(<String, dynamic>{
          "query_string": query,
          "base64_columns": [],
        }),
      );
      if (response.statusCode == 200) {
        String source = Utf8Decoder().convert(response.bodyBytes);
        dynamic decoded = jsonDecode(source);
        List list = decoded['data'];
        List<TblDkTableCategory> tableCategories = list.map((e) => TblDkTableCategory.fromMap(e)).toList();
        return tableCategories;
      }
    }
    return [];
  }

  Future<List<TblMgCategory>> getCategories() async {
    String query = '''select cat_id, 
                      cat_name,
                      cat_name_tm,
                      cat_name_ru,
                      cat_name_en,
                      cat_order
                      --,cat_image 
                      from tbl_mg_category''';
    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.readData(query);
            if (result != null) {
              List decoded = jsonDecode(result);
              return decoded.map((e) => TblMgCategory.fromMap(e)).toList();
            }
          }
        } catch (e) {
          debugPrint("Error on QueryFromApi.getCategories: ${e.toString()}");
        }
      }
    } else {
      Uri uri = Uri.http(baseUrl, basePath);
      var response = await http.post(
        uri,
        body: jsonEncode(<String, dynamic>{
          "query_string": query,
          "base64_columns": ["cat_image"],
        }),
      );
      if (response.statusCode == 200) {
        String source = Utf8Decoder().convert(response.bodyBytes);
        dynamic decoded = jsonDecode(source);
        List list = decoded['data'];
        List<TblMgCategory> categories = list.map((e) => TblMgCategory.fromMap(e)).toList();
        return categories;
      }
    }
    return [];
  }

  Future<ImageModel?> getMatImage(int matId, String imgGuid) async {
    String query = '''select TOP(1) image_id, material_id, image_pict,image_id_guid from tbl_mg_images
                      where material_id=$matId and image_id_guid not like \'$imgGuid\'''';
    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.readData(query);
            if (result != null) {
              List decoded = jsonDecode(result);
              return (decoded.isNotEmpty) ? ImageModel.fromMap(decoded[0]) : null;
            }
          }
        } catch (e) {
          debugPrint("Error on getMatImage: ${e.toString()}");
        }
      }
    } else {
      Uri uri = Uri.http(baseUrl, basePath);
      var response = await http.post(
        uri,
        body: jsonEncode(<String, dynamic>{
          "query_string": query,
          "base64_columns": ["image_pict"],
        }),
      );
      if (response.statusCode == 200) {
        String source = Utf8Decoder().convert(response.bodyBytes);
        dynamic decoded = jsonDecode(source);
        List list = decoded['data'];
        return ImageModel.fromMap(list[0]);
      }
    }
    return null;
  }

  Future<ImageModel?> getCatImage(int catId, String imgGuid) async {
    String query = '''select Top(1) cat_id,cat_image,cat_id_guid
                      from tbl_mg_category
                      where cat_id=$catId and cat_id_guid not like \'$imgGuid\' ''';
    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.readData(query);
            if (result != null) {
              List decoded = jsonDecode(result);
              return (decoded.isNotEmpty) ? ImageModel.fromMap(decoded[0]) : null;
            }
          }
        } catch (e) {
          debugPrint("Error on getCatImage: ${e.toString()}");
        }
      }
    } else {
      Uri uri = Uri.http(baseUrl, basePath);
      var response = await http.post(
        uri,
        body: jsonEncode(<String, dynamic>{
          "query_string": query,
          "base64_columns": ["cat_image"],
        }),
      );
      if (response.statusCode == 200) {
        String source = Utf8Decoder().convert(response.bodyBytes);
        dynamic decoded = jsonDecode(source);
        List list = decoded['data'];
        return ImageModel.fromMap(list[0]);
      }
    }
    return null;
  }

  Future<List<TblMgMaterials>> getMaterial() async {
    String query = '''select m.material_id, material_code,material_name, m.security_code, security_code_name, bar_barcode,price_value,--  image_pict, 
                      mat_auto_price, m.group_code, cat_id, mat_name_lang1, mat_name_lang2, mat_name_lang3,
                      ISNULL((Select JSON=[dbo].[StrJSON](0,1,(Select * From tbl_mg_mat_attributes where material_id=m.material_id for XML RAW))),'') as mat_attributes,
                      spe_code2, spe_code3, spe_code4,m.a_status_id from tbl_mg_materials m
                      left outer join tbl_mg_barcode b on m.material_id = b.material_id
                      left outer join tbl_mg_images i on m.material_id = i.material_id
                      left outer join tbl_mg_mat_price mp on m.material_id = mp.material_id
                      left outer join tbl_mg_security_code s on m.security_code = s.security_code
                      where price_type_id=2 and m_cat_id not in (19,20) and m.a_status_id in (1,2)''';
    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.readData(query);
            if (result != null) {
              List decoded = jsonDecode(result);
              return decoded.map((e) => TblMgMaterials.fromMap(e)).toList();
            }
          }
        } catch (e) {
          debugPrint("Error from getMaterial(): ${e.toString()}");
        }
      }
    } else {
      Uri uri = Uri.http(baseUrl, basePath);
      var response = await http.post(
        uri,
        body: jsonEncode(<String, dynamic>{
          "query_string": query,
          "base64_columns": ["image_pict"],
        }),
      );
      if (response.statusCode == 200) {
        try {
          String source = Utf8Decoder().convert(response.bodyBytes);
          dynamic decoded = jsonDecode(source);
          List list = decoded['data'];
          List<TblMgMaterials> materials = list.map((e) => TblMgMaterials.fromMap(e)).toList();
          return materials;
        } catch (e) {
          print(e.toString());
          return [];
        }
      }
    }
    return [];
  }

  Future<List<TblMgMaterials>> getMaterialByCat(int id) async {
    String query =
        '''select material_name, bar_barcode, image_pict, price_value, group_code, cat_id, mat_name_lang1, mat_name_lang2, mat_name_lang3, material_description,m.a_status_id from tbl_mg_materials m
                      left outer join tbl_mg_barcode b on m.material_id = b.material_id
                      left outer join tbl_mg_images i on m.material_id = i.material_id
                      left outer join tbl_mg_mat_price mp on m.material_id = mp.material_id
                      where price_type_id=2 and cat_id=$id and m_cat_id not in (19,20) and m.a_status_id in (1,2)''';
    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.readData(query);
            if (result != null) {
              List decoded = jsonDecode(result);
              return decoded.map((e) => TblMgMaterials.fromMap(e)).toList();
            }
          }
        } catch (e) {
          debugPrint("Error on getMaterialByCat: ${e.toString()}");
        }
      }
    } else {
      Uri uri = Uri.http(baseUrl, basePath);
      var response = await http.post(
        uri,
        body: jsonEncode(<String, dynamic>{
          "query_string": query,
          "base64_columns": ["image_pict"],
        }),
      );
      if (response.statusCode == 200) {
        String source = Utf8Decoder().convert(response.bodyBytes);
        dynamic decoded = jsonDecode(source);
        List list = decoded['data'];
        List<TblMgMaterials> materials = list.map((e) => TblMgMaterials.fromMap(e)).toList();
        return materials;
      }
    }
    return [];
  }

  Future<List<CustomOrderFich>> getOrderFich(int id) async {
    String query = "SELECT * FROM tbl_mg_order_fich WHERE fich_id = $id";
    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.readData(query);
            if (result != null) {
              List decoded = jsonDecode(result);
              return decoded.map((e) => CustomOrderFich.fromMap(e)).toList();
            }
          }
        } catch (e) {
          debugPrint("Error on QueryFromApi.getOrderFich: ${e.toString()}");
        }
      }
    } else {
      Uri uri = Uri.http(baseUrl, basePath);
      var response = await http.post(
        uri,
        body: jsonEncode(<String, dynamic>{
          "query_string": query,
          "base64_columns": ["image_pict"],
        }),
      );
      if (response.statusCode == 200) {
        String source = Utf8Decoder().convert(response.bodyBytes);
        dynamic decoded = jsonDecode(source);
        List list = decoded['data'];
        List<CustomOrderFich> orderFich = list.map((e) => CustomOrderFich.fromMap(e)).toList();
        return orderFich;
      }
    }
    return [];
  }

  Future<List<CustomFichLine>> getFichLines(int id) async {
    String query = '''SELECT 
                      fich_line_id,
                      material_name,
                      m.security_code,
                      s.security_code_name,
                      mat_name_lang1,
                      mat_name_lang2,
                      mat_name_lang3,
                      fich_line_amount,
                      fich_line_price,
                      fich_line_total,
                      f.fich_id,
                      o.fich_code,
                      f.material_id,
                      fich_line_desc,
                      fich_line_disc_prc,
                      fich_line_disc_amount,
                      fich_line_nettotal,
                      fich_line_date,
                      fich_line_id_guid,
                      f.fich_id_guid,
                      image_pict,
                      f.spe_code1
                      FROM tbl_mg_order_fich_line f
                      LEFT OUTER JOIN tbl_mg_images i on i.material_id=f.material_id
                      LEFT OUTER JOIN tbl_mg_materials m on m.material_id=f.material_id
                      LEFT OUTER JOIN tbl_mg_security_code s on s.security_code=m.security_code
                      LEFT OUTER JOIN tbl_mg_order_fich o on f.fich_id=o.fich_id
                      WHERE f.fich_id=$id
                    ''';
    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.readData(query);
            if (result != null) {
              List decoded = jsonDecode(result);
              return decoded.map((e) => CustomFichLine.fromMap(e)).toList();
            }
          }
        } catch (e) {
          debugPrint("Error on QueryFromApi.getFichLines: ${e.toString()}");
        }
      }
    } else {
      Uri uri = Uri.http(baseUrl, basePath);
      var response = await http.post(
        uri,
        body: jsonEncode(<String, dynamic>{
          "query_string": query,
          "base64_columns": ['image_pict'],
        }),
      );
      if (response.statusCode == 200) {
        String source = Utf8Decoder().convert(response.bodyBytes);
        dynamic decoded = jsonDecode(source);
        List list = decoded['data'];
        List<CustomFichLine> fichLines = list.map((e) => CustomFichLine.fromMap(e)).toList();
        return fichLines;
      }
    }
    return [];
  }

  Future<List<CustomFichLine>> deleteFichLine(CustomFichLine fichLine) async {
    String query =
        "select fich_total, fich_nettotal, fich_discount, fich_total_unit_amount, fich_id_guid from tbl_mg_order_fich where fich_id = ${fichLine.fichId}";
    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.readData(query);
            if (result != null) {
              List list = jsonDecode(result);
              double fichTotal = double.parse(list[0]['fich_total']);
              double fichNettotal = double.parse(list[0]['fich_nettotal']);
              double fichTotalUnit = double.parse(list[0]['fich_total_unit_amount']);
              var result2 = await SqlConn.readData('''
                                                    UPDATE tbl_mg_order_fich SET 
                                                    fich_total=${fichTotal - fichLine.fichLineTotal}, 
                                                    fich_nettotal=${fichNettotal - fichLine.fichLineNettotal}, 
                                                    fich_total_unit_amount=${fichTotalUnit - 1},
                                                    fich_modify_date=convert(datetime, GETDATE(), 104) 
                                                    where fich_id=${fichLine.fichId};
                                                    DELETE FROM tbl_mg_order_fich_line where fich_line_id=${fichLine.fichLineId};
                                                    SELECT 
                                                      fich_line_id,
                                                      material_name,
                                                      m.security_code,
                                                      s.security_code_name,
                                                      mat_name_lang1,
                                                      mat_name_lang2,
                                                      mat_name_lang3,
                                                      fich_line_amount,
                                                      fich_line_price,
                                                      fich_line_total,
                                                      f.fich_id,
                                                      o.fich_code,
                                                      f.material_id,
                                                      fich_line_desc,
                                                      fich_line_disc_prc,
                                                      fich_line_disc_amount,
                                                      fich_line_nettotal,
                                                      fich_line_date,
                                                      fich_line_id_guid,
                                                      f.fich_id_guid,
                                                      image_pict
                                                      FROM tbl_mg_order_fich_line f
                                                      LEFT OUTER JOIN tbl_mg_images i on i.material_id=f.material_id
                                                      LEFT OUTER JOIN tbl_mg_materials m on m.material_id=f.material_id
                                                      LEFT OUTER JOIN tbl_mg_security_code s on s.security_code=m.security_code
                                                      LEFT OUTER JOIN tbl_mg_order_fich o on f.fich_id=o.fich_id
                                                  WHERE f.fich_id=${fichLine.fichId};
                                                  ''');
              List decoded = jsonDecode(result2);
              return decoded.map((e) => CustomFichLine.fromMap(e)).toList();
            }
          }
        } catch (e) {
          debugPrint("Error on QueryFromApi.deleteFichLines: ${e.toString()}");
        }
      }
    } else {
      Uri uri = Uri.http(baseUrl, basePath);
      http.Response orderFich = await http.post(
        uri,
        body: jsonEncode(<String, dynamic>{
          'query_string': query,
        }),
      );
      // print('response: ${orderFich.body}');
      if (orderFich.statusCode == 200) {
        List list = jsonDecode(orderFich.body)['data'];
        double fichTotal = double.parse(list[0]['fich_total']);
        double fichNettotal = double.parse(list[0]['fich_nettotal']);
        double fichTotalUnit = double.parse(list[0]['fich_total_unit_amount']);

        http.Response response = await http.post(
          uri,
          body: jsonEncode(<String, dynamic>{
            'query_string': '''
            UPDATE tbl_mg_order_fich SET 
            fich_total=${fichTotal - fichLine.fichLineTotal}, 
            fich_nettotal=${fichNettotal - fichLine.fichLineNettotal}, 
            fich_total_unit_amount=${fichTotalUnit - 1},
            fich_modify_date=convert(datetime, GETDATE(), 104) 
            where fich_id=${fichLine.fichId};
            DELETE FROM tbl_mg_order_fich_line where fich_line_id=${fichLine.fichLineId};
            SELECT 
              fich_line_id,
              material_name,
			        m.security_code,
			        s.security_code_name,
              mat_name_lang1,
              mat_name_lang2,
              mat_name_lang3,
              fich_line_amount,
              fich_line_price,
              fich_line_total,
              f.fich_id,
			        o.fich_code,
              f.material_id,
              fich_line_desc,
              fich_line_disc_prc,
              fich_line_disc_amount,
              fich_line_nettotal,
              fich_line_date,
              fich_line_id_guid,
              f.fich_id_guid,
              image_pict
              FROM tbl_mg_order_fich_line f
              LEFT OUTER JOIN tbl_mg_images i on i.material_id=f.material_id
              LEFT OUTER JOIN tbl_mg_materials m on m.material_id=f.material_id
			        LEFT OUTER JOIN tbl_mg_security_code s on s.security_code=m.security_code
					    LEFT OUTER JOIN tbl_mg_order_fich o on f.fich_id=o.fich_id
          WHERE f.fich_id=${fichLine.fichId};
          ''',
            "base64_columns": ['image_pict'],
          }),
        );
        if (response.statusCode == 200) {
          String source = Utf8Decoder().convert(response.bodyBytes);
          dynamic decoded = jsonDecode(source);
          List list = decoded != null ? decoded['data'] : [];
          List<CustomFichLine> fichLines = list.map((e) => CustomFichLine.fromMap(e)).toList();
          return fichLines;
        } else {
          return [];
        }
      }
    }
    return [];
  }

  Future<List<CustomFichLine>> deleteUpdateFichLines(
    List<CustomFichLine> deletes,
    List<CustomFichLine> updates,
  ) async {
    String query =
        "select fich_total, fich_nettotal, fich_discount, fich_total_unit_amount, fich_id_guid from tbl_mg_order_fich where fich_id = ${deletes.first.fichId}";
    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.readData(query);
            if (result != null) {
              List list = jsonDecode(result);
              double fichTotal = double.parse(list[0]['fich_total']);
              double fichNettotal = double.parse(list[0]['fich_nettotal']);
              double fichTotalUnit = double.parse(list[0]['fich_total_unit_amount']);
              String values = deletes.map((fichLine) => '''
                DELETE FROM tbl_mg_order_fich_line where fich_line_id=${fichLine.fichLineId};
              ''').toList().join(';');

              String update = updates.map((fichLine) => '''
                UPDATE tbl_mg_order_fich_line SET
                fich_line_amount = ${fichLine.fichLineAmount},
                fich_line_total = ${fichLine.fichLineTotal},
                fich_line_nettotal = ${fichLine.fichLineNettotal}
                WHERE fich_line_id = ${fichLine.fichId};
              ''').toList().join(',');

              double total = deletes.map((e) => e.fichLinePrice * e.fichLineAmount).toList().reduce((value, element) => value + element) +
                  updates.map((e) => e.fichLinePrice * e.fichLineAmount).toList().reduce((value, element) => value + element);

              var result2 = await SqlConn.readData('''
                                                  UPDATE tbl_mg_order_fich SET 
                                                  fich_total=${fichTotal - total}, 
                                                  fich_nettotal=${fichNettotal - total}, 
                                                  fich_total_unit_amount=${fichTotalUnit - deletes.length},
                                                  fich_modify_date=convert(datetime, GETDATE(), 104) 
                                                  where fich_id=${deletes.first.fichId};
                                                  $values
                                                  $update
                                                  SELECT 
                                                    fich_line_id,
                                                    material_name,
                                                    m.security_code,
                                                    s.security_code_name,
                                                    mat_name_lang1,
                                                    mat_name_lang2,
                                                    mat_name_lang3,
                                                    fich_line_amount,
                                                    fich_line_price,
                                                    fich_line_total,
                                                    f.fich_id,
                                                    o.fich_code,
                                                    f.material_id,
                                                    fich_line_desc,
                                                    fich_line_disc_prc,
                                                    fich_line_disc_amount,
                                                    fich_line_nettotal,
                                                    fich_line_date,
                                                    fich_line_id_guid,
                                                    f.fich_id_guid,
                                                    image_pict
                                                    FROM tbl_mg_order_fich_line f
                                                    LEFT OUTER JOIN tbl_mg_images i on i.material_id=f.material_id
                                                    LEFT OUTER JOIN tbl_mg_materials m on m.material_id=f.material_id
                                                    LEFT OUTER JOIN tbl_mg_security_code s on s.security_code=m.security_code
                                                    LEFT OUTER JOIN tbl_mg_order_fich o on f.fich_id=o.fich_id
                                                WHERE f.fich_id=${deletes.first.fichId};
                                                ''');
              List decoded = jsonDecode(result2);
              return decoded.map((e) => CustomFichLine.fromMap(e)).toList();
            }
          }
        } catch (e) {
          debugPrint("Error on QueryFromApi.deleteUpdateFichLines: ${e.toString()}");
        }
      }
    } else {
      Uri uri = Uri.http(baseUrl, basePath);
      http.Response orderFich = await http.post(
        uri,
        body: jsonEncode(<String, dynamic>{
          'query_string': query,
        }),
      );
      // print('response: ${orderFich.body}');
      if (orderFich.statusCode == 200) {
        List list = jsonDecode(orderFich.body)['data'];
        double fichTotal = double.parse(list[0]['fich_total']);
        double fichNettotal = double.parse(list[0]['fich_nettotal']);
        // double fichDiscount = double.parse(list[0]['fich_discount']);
        double fichTotalUnit = double.parse(list[0]['fich_total_unit_amount']);

        String values = deletes.map((fichLine) => '''
        DELETE FROM tbl_mg_order_fich_line where fich_line_id=${fichLine.fichLineId};
      ''').toList().join(';');

        String update = updates.map((fichLine) => '''
        UPDATE tbl_mg_order_fich_line SET
        fich_line_amount = ${fichLine.fichLineAmount},
        fich_line_total = ${fichLine.fichLineTotal},
        fich_line_nettotal = ${fichLine.fichLineNettotal}
        WHERE fich_line_id = ${fichLine.fichId};
      ''').toList().join(',');

        double total = deletes.map((e) => e.fichLinePrice * e.fichLineAmount).toList().reduce((value, element) => value + element) +
            updates.map((e) => e.fichLinePrice * e.fichLineAmount).toList().reduce((value, element) => value + element);

        http.Response response = await http.post(
          uri,
          body: jsonEncode(<String, dynamic>{
            'query_string': '''
            UPDATE tbl_mg_order_fich SET 
            fich_total=${fichTotal - total}, 
            fich_nettotal=${fichNettotal - total}, 
            fich_total_unit_amount=${fichTotalUnit - deletes.length},
            fich_modify_date=convert(datetime, GETDATE(), 104) 
            where fich_id=${deletes.first.fichId};
            $values
            $update
            SELECT 
              fich_line_id,
              material_name,
			        m.security_code,
			        s.security_code_name,
              mat_name_lang1,
              mat_name_lang2,
              mat_name_lang3,
              fich_line_amount,
              fich_line_price,
              fich_line_total,
              f.fich_id,
			        o.fich_code,
              f.material_id,
              fich_line_desc,
              fich_line_disc_prc,
              fich_line_disc_amount,
              fich_line_nettotal,
              fich_line_date,
              fich_line_id_guid,
              f.fich_id_guid,
              image_pict
              FROM tbl_mg_order_fich_line f
              LEFT OUTER JOIN tbl_mg_images i on i.material_id=f.material_id
              LEFT OUTER JOIN tbl_mg_materials m on m.material_id=f.material_id
			        LEFT OUTER JOIN tbl_mg_security_code s on s.security_code=m.security_code
					    LEFT OUTER JOIN tbl_mg_order_fich o on f.fich_id=o.fich_id
          WHERE f.fich_id=${deletes.first.fichId};
          ''',
            "base64_columns": ['image_pict'],
          }),
        );
        if (response.statusCode == 200) {
          String source = Utf8Decoder().convert(response.bodyBytes);
          dynamic decoded = jsonDecode(source);
          List list = decoded != null ? decoded['data'] : [];
          List<CustomFichLine> fichLines = list.map((e) => CustomFichLine.fromMap(e)).toList();
          return fichLines;
        } else {
          return [];
        }
      }
    }
    return [];
  }

  Future<List<CustomFichLine>> deleteFichLines(List<CustomFichLine> deletes) async {
    String query =
        "select fich_total, fich_nettotal, fich_discount, fich_total_unit_amount, fich_id_guid from tbl_mg_order_fich where fich_id = ${deletes.first.fichId}";
    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.readData(query);
            if (result != null) {
              List list = jsonDecode(result);
              double fichTotal = double.parse(list[0]['fich_total']);
              double fichNettotal = double.parse(list[0]['fich_nettotal']);
              double fichTotalUnit = double.parse(list[0]['fich_total_unit_amount']);
              String values = deletes.map((fichLine) => '''
                DELETE FROM tbl_mg_order_fich_line where fich_line_id=${fichLine.fichLineId};
              ''').toList().join(';');

              double total = deletes.map((e) => e.fichLinePrice * e.fichLineAmount).toList().reduce((value, element) => value + element);

              var result2 = await SqlConn.readData('''
                                                    UPDATE tbl_mg_order_fich SET 
                                                    fich_total=${fichTotal - total}, 
                                                    fich_nettotal=${fichNettotal - total}, 
                                                    fich_total_unit_amount=${fichTotalUnit - deletes.length},
                                                    fich_modify_date=convert(datetime, GETDATE(), 104) 
                                                    where fich_id=${deletes.first.fichId};
                                                    $values
                                                    SELECT 
                                                      fich_line_id,
                                                      material_name,
                                                      m.security_code,
                                                      s.security_code_name,
                                                      mat_name_lang1,
                                                      mat_name_lang2,
                                                      mat_name_lang3,
                                                      fich_line_amount,
                                                      fich_line_price,
                                                      fich_line_total,
                                                      f.fich_id,
                                                      o.fich_code,
                                                      f.material_id,
                                                      fich_line_desc,
                                                      fich_line_disc_prc,
                                                      fich_line_disc_amount,
                                                      fich_line_nettotal,
                                                      fich_line_date,
                                                      fich_line_id_guid,
                                                      f.fich_id_guid,
                                                      image_pict
                                                      FROM tbl_mg_order_fich_line f
                                                      LEFT OUTER JOIN tbl_mg_images i on i.material_id=f.material_id
                                                      LEFT OUTER JOIN tbl_mg_materials m on m.material_id=f.material_id
                                                      LEFT OUTER JOIN tbl_mg_security_code s on s.security_code=m.security_code
                                                      LEFT OUTER JOIN tbl_mg_order_fich o on f.fich_id=o.fich_id
                                                  WHERE f.fich_id=${deletes.first.fichId};
                                                  ''');
              List decodedList = jsonDecode(result2);
              return decodedList.map((e) => CustomFichLine.fromMap(e)).toList();
            }
          }
        } catch (e) {
          debugPrint("Error on QueryFromApi.deleteFichLines: ${e.toString()}");
        }
      }
    } else {
      Uri uri = Uri.http(baseUrl, basePath);
      http.Response orderFich = await http.post(
        uri,
        body: jsonEncode(<String, dynamic>{
          'query_string': query,
        }),
      );
      // print('response: ${orderFich.body}');
      if (orderFich.statusCode == 200) {
        List list = jsonDecode(orderFich.body)['data'];
        double fichTotal = double.parse(list[0]['fich_total']);
        double fichNettotal = double.parse(list[0]['fich_nettotal']);
        // double fichDiscount = double.parse(list[0]['fich_discount']);
        double fichTotalUnit = double.parse(list[0]['fich_total_unit_amount']);

        String values = deletes.map((fichLine) => '''
        DELETE FROM tbl_mg_order_fich_line where fich_line_id=${fichLine.fichLineId};
      ''').toList().join(';');

        double total = deletes.map((e) => e.fichLinePrice * e.fichLineAmount).toList().reduce((value, element) => value + element);

        http.Response response = await http.post(
          uri,
          body: jsonEncode(<String, dynamic>{
            'query_string': '''
            UPDATE tbl_mg_order_fich SET 
            fich_total=${fichTotal - total}, 
            fich_nettotal=${fichNettotal - total}, 
            fich_total_unit_amount=${fichTotalUnit - deletes.length},
            fich_modify_date=convert(datetime, GETDATE(), 104) 
            where fich_id=${deletes.first.fichId};
            $values
            SELECT 
              fich_line_id,
              material_name,
			        m.security_code,
			        s.security_code_name,
              mat_name_lang1,
              mat_name_lang2,
              mat_name_lang3,
              fich_line_amount,
              fich_line_price,
              fich_line_total,
              f.fich_id,
			        o.fich_code,
              f.material_id,
              fich_line_desc,
              fich_line_disc_prc,
              fich_line_disc_amount,
              fich_line_nettotal,
              fich_line_date,
              fich_line_id_guid,
              f.fich_id_guid,
              image_pict
              FROM tbl_mg_order_fich_line f
              LEFT OUTER JOIN tbl_mg_images i on i.material_id=f.material_id
              LEFT OUTER JOIN tbl_mg_materials m on m.material_id=f.material_id
			        LEFT OUTER JOIN tbl_mg_security_code s on s.security_code=m.security_code
					    LEFT OUTER JOIN tbl_mg_order_fich o on f.fich_id=o.fich_id
          WHERE f.fich_id=${deletes.first.fichId};
          ''',
            "base64_columns": ['image_pict'],
          }),
        );
        if (response.statusCode == 200) {
          String source = Utf8Decoder().convert(response.bodyBytes);
          dynamic decoded = jsonDecode(source);
          List list = decoded != null ? decoded['data'] : [];
          List<CustomFichLine> fichLines = list.map((e) => CustomFichLine.fromMap(e)).toList();
          return fichLines;
        } else {
          return [];
        }
      }
    }

    return [];
  }

  Future<bool> insertFichLines(tbl.Table table, List<CartItem> cartItems) async {
    String query =
        "select fich_total, fich_nettotal, fich_discount, fich_total_unit_amount, fich_id_guid from tbl_mg_order_fich where fich_id = ${table.fichId}";
    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.readData(query);
            if (result != null) {
              List list = jsonDecode(result);
              String fichIdGuid = list[0]['fich_id_guid'].toString();
              double fichTotal = double.tryParse(list[0]['fich_total']?.toString() ?? '0.0') ?? 0.0;
              double fichNettotal = double.tryParse(list[0]['fich_nettotal']?.toString() ?? '0.0') ?? 0.0;
              // double fichDiscount = double.parse(list[0]['fich_discount']);
              double fichTotalUnit = double.tryParse(list[0]['fich_total_unit_amount']?.toString() ?? '0.0') ?? 0.0;
              double total = cartItems.map((e) => e.material.salePrice * e.count).toList().reduce((value, element) => value + element);
              String values = cartItems.map((e) {
                String _attr = '';
                for (TblMgMatAttributes attr in e.matAttributes) {
                  _attr = ((_attr.isNotEmpty) ? _attr + ',' : '') + attr.mat_attribute_name;
                }
                return '''
                  (${e.count},
                  ${e.material.salePrice},
                  ${e.count * e.material.salePrice},
                  0,
                  ${table.fichId},
                  ${e.material.id},
                  '${(e.fich_line_desc.toString())}',
                  1,
                  0,
                  0,
                  ${e.count * e.material.salePrice},
                  convert(datetime, GETDATE(), 104),
                  0,
                  convert(datetime, '1900-01-01 00:00:00.000'),
                  '',
                  0,
                  0.000,
                  0.000,
                  0,
                  '',
                  '',
                  '',
                  '$fichIdGuid',
                  '$_attr'
                  )
                ''';
              }).join(',');
              var result2 = await SqlConn.writeData('''
                                                    UPDATE tbl_mg_order_fich SET 
                                                    fich_total=${fichTotal + total}, 
                                                    fich_nettotal=${fichNettotal + total}, 
                                                    fich_total_unit_amount=${fichTotalUnit + cartItems.length},
                                                    spe_code='${table.speCode.toString()}',
                                                    group_code='${table.groupCode.toString()}',
                                                    security_code='${table.securityCode.toString()}',
                                                    fich_desc='${table.invDesc.toString()}',
                                                    fich_modify_date=convert(datetime, GETDATE(), 104) 
                                                    where fich_id=${table.fichId};
                                                    INSERT INTO tbl_mg_order_fich_line (
                                                    fich_line_amount,
                                                    fich_line_price,
                                                    fich_line_total,
                                                    inv_id,
                                                    fich_id,
                                                    material_id,
                                                    fich_line_desc,
                                                    unit_det_id,
                                                    fich_line_disc_prc,
                                                    fich_line_disc_amount,
                                                    fich_line_nettotal,
                                                    fich_line_date,
                                                    service_id,
                                                    fich_line_expiredate,
                                                    fich_line_serialno,
                                                    mat_inv_line_id,
                                                    rep_rate,
                                                    rep_total,
                                                    fich_line_type_id,
                                                    spe_code,
                                                    group_code,
                                                    security_code,
                                                    fich_id_guid,
                                                    spe_code1
                                                  ) VALUES $values
                                                  ''');
              if (result2 != null) {
                return true;
              }
            }
          }
        } catch (e) {
          debugPrint("Error on QueryFromApi.insertFichLines: ${e.toString()}");
        }
        return false;
      }
    } else {
      Uri uriInsert = Uri.http(baseUrl, basePath, {cud: '1'});
      Uri uri = Uri.http(baseUrl, basePath);
      http.Response orderFich = await http.post(
        uri,
        body: jsonEncode(<String, dynamic>{
          'query_string': query,
        }),
      );
      if (orderFich.statusCode == 200) {
        List list = jsonDecode(orderFich.body)['data'];
        String fichIdGuid = list[0]['fich_id_guid'].toString();
        double fichTotal = double.parse(list[0]['fich_total']);
        double fichNettotal = double.parse(list[0]['fich_nettotal']);
        // double fichDiscount = double.parse(list[0]['fich_discount']);
        double fichTotalUnit = double.parse(list[0]['fich_total_unit_amount']);
        double total = cartItems.map((e) => e.material.salePrice * e.count).toList().reduce((value, element) => value + element);
        String values = cartItems.map((e) {
          String _attr = '';
          for (TblMgMatAttributes attr in e.matAttributes) {
            _attr = ((_attr.isNotEmpty) ? _attr + ',' : '') + attr.mat_attribute_name;
          }
          return '''
          (${e.count},
          ${e.material.salePrice},
          ${e.count * e.material.salePrice},
          0,
          ${table.fichId},
          ${e.material.id},
          '${(e.fich_line_desc.toString())}',
          1,
          0,
          0,
          ${e.count * e.material.salePrice},
          convert(datetime, GETDATE(), 104),
          0,
          convert(datetime, '1900-01-01 00:00:00.000'),
          '',
          0,
          0.000,
          0.000,
          0,
          '',
          '',
          '',
          '$fichIdGuid',
          '$_attr'
          )
        ''';
        }).join(',');
        http.Response response = await http.post(
          uriInsert,
          body: jsonEncode(<String, dynamic>{
            'query_string': '''
            UPDATE tbl_mg_order_fich SET 
            fich_total=${fichTotal + total}, 
            fich_nettotal=${fichNettotal + total}, 
            fich_total_unit_amount=${fichTotalUnit + cartItems.length},
            spe_code='${table.speCode.toString()}',
            group_code='${table.groupCode.toString()}',
            security_code='${table.securityCode.toString()}',
            fich_desc='${table.invDesc.toString()}',
            fich_modify_date=convert(datetime, GETDATE(), 104) 
            where fich_id=${table.fichId};
            INSERT INTO tbl_mg_order_fich_line (
            fich_line_amount,
            fich_line_price,
            fich_line_total,
            inv_id,
            fich_id,
            material_id,
            fich_line_desc,
            unit_det_id,
            fich_line_disc_prc,
            fich_line_disc_amount,
            fich_line_nettotal,
            fich_line_date,
            service_id,
            fich_line_expiredate,
            fich_line_serialno,
            mat_inv_line_id,
            rep_rate,
            rep_total,
            fich_line_type_id,
            spe_code,
            group_code,
            security_code,
            fich_id_guid,
            spe_code1
          ) VALUES $values
          ''',
          }),
        );
        if (response.statusCode == 200) {
          return true;
        }
        return false;
      }
    }

    return false;
  }

  Future<Map<String, dynamic>?> insertWithFich(List<CartItem> cartItems, tbl.Table table, TblMgSalesman? salesman) async {
    String fichCode = DateTime.now().millisecondsSinceEpoch.toString() + getRandomString(5);
    String query = '''
          INSERT INTO tbl_mg_order_fich (
            fich_code,
            fich_date,
            fich_total,
            fich_create_date,
            fich_type_id,
            arap_id,
            div_id,
            dept_id,
            plant_id,
            wh_id,
            p_id,
            inv_id,
            fich_desc,
            fich_discount,
            fich_nettotal,
            salesman_id,
            T_ID,
            spe_code,
            group_code,
            security_code,
            payplan_id,
            ord_status_id,
            rep_rate,
            rep_total,
            fich_modify_date,
            fich_total_unit_amount,
            fich_modified,
            bank_acc_id_client,
            bank_acc_id_local,
            delivery_arap_id,
            sync_datetime,
            order_lat,
            order_long,
            fich_nettotal_text
          ) values(
            '$fichCode',
            convert(datetime, GETDATE(), 104) 
            ,0	
            ,convert(datetime, GETDATE(), 104)
            ,12	
            ,${table.arapId.toString()}
            ,1	
            ,1	
            ,1	
            ,1	
            ,1	
            ,0
            ,'${table.invDesc.toString()}'	
            ,0.00000	
            ,0.00000	
            ,${salesman?.salesmanId ?? 0}	
            ,2010	
            ,'${table.speCode.toString()}'
            ,'${table.groupCode.toString()}'	
            ,'${table.securityCode.toString()}'
            ,0	
            ,0	
            ,0.00000	
            ,0.00000	
            ,convert(datetime, GETDATE(), 104)	
            ,0.00000	
            ,0	
            ,0	
            ,0	
            ,0	
            ,NULL	
            ,0.0000000000	
            ,0.0000000000
            ,''
          );
          SELECT * FROM tbl_mg_order_fich WHERE fich_code='$fichCode';
        ''';
    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.readData(query);
            if (result != null) {
              List list = jsonDecode(result);
              String fichId = list[0]['fich_id'].toString();
              String fichIdGuid = list[0]['fich_id_guid'].toString();
              double total = cartItems.map((e) => e.material.salePrice * e.count).toList().reduce((value, element) => value + element);
              String values = cartItems.map((e) {
                String _attr = '';
                for (TblMgMatAttributes attr in e.matAttributes) {
                  _attr = _attr + ',' + attr.mat_attribute_name;
                }
                return '''
                      (${e.count},
                      ${e.material.salePrice},
                      ${e.count * e.material.salePrice},
                      0,
                      $fichId,
                      ${e.material.id},
                      '${e.fich_line_desc.toString()}',
                      1,
                      0,
                      0,
                      ${e.count * e.material.salePrice},
                      convert(datetime, GETDATE(), 104),
                      0,
                      convert(datetime, '1900-01-01 00:00:00.000'),
                      '',
                      0,
                      0.000,
                      0.000,
                      0,
                      '',
                      '',
                      '',
                      '$fichIdGuid',
                      '$_attr'
                      )
                    ''';
              }).join(',');

              var result2 = await SqlConn.writeData('''
                              UPDATE tbl_mg_order_fich SET 
                                fich_total=$total,
                                fich_nettotal=$total,
                                fich_total_unit_amount=${cartItems.length},
                                fich_modify_date=convert(datetime, GETDATE(), 104)
                                where fich_id=$fichId;
                                INSERT INTO tbl_mg_order_fich_line (
                                fich_line_amount,
                                fich_line_price,
                                fich_line_total,
                                inv_id,
                                fich_id,
                                material_id,
                                fich_line_desc,
                                unit_det_id,
                                fich_line_disc_prc,
                                fich_line_disc_amount,
                                fich_line_nettotal,
                                fich_line_date,
                                service_id,
                                fich_line_expiredate,
                                fich_line_serialno,
                                mat_inv_line_id,
                                rep_rate,
                                rep_total,
                                fich_line_type_id,
                                spe_code,
                                group_code,
                                security_code,
                                fich_id_guid,
                                spe_code1
                              ) VALUES $values;
                                                  ''');
              if (result2 != null) {
                return {"fich_code": fichCode, "fich_id": fichId};
              }
              return null;
            }
          }
        } catch (e) {
          debugPrint("Error on QueryFromApi.insertWithFich: ${e.toString()}");
        }
      }
    } else {
      String fichCode = DateTime.now().millisecondsSinceEpoch.toString() + getRandomString(5);
      Uri uriInsert = Uri.http(baseUrl, basePath, {cud: '1'});
      Uri uri = Uri.http(baseUrl, basePath);
      http.Response orderFich = await http.post(
        uri,
        body: jsonEncode(<String, dynamic>{
          'query_string': query,
        }),
      );
      if (orderFich.statusCode == 200) {
        List list = jsonDecode(orderFich.body)['data'];
        String fichId = list[0]['fich_id'].toString();
        String fichIdGuid = list[0]['fich_id_guid'].toString();
        double total = cartItems.map((e) => e.material.salePrice * e.count).toList().reduce((value, element) => value + element);
        String values = cartItems.map((e) {
          String _attr = '';
          for (TblMgMatAttributes attr in e.matAttributes) {
            _attr = _attr + ',' + attr.mat_attribute_name;
          }
          return '''
          (${e.count},
          ${e.material.salePrice},
          ${e.count * e.material.salePrice},
          0,
          $fichId,
          ${e.material.id},
          '${e.fich_line_desc.toString()}',
          1,
          0,
          0,
          ${e.count * e.material.salePrice},
          convert(datetime, GETDATE(), 104),
          0,
          convert(datetime, '1900-01-01 00:00:00.000'),
          '',
          0,
          0.000,
          0.000,
          0,
          '',
          '',
          '',
          '$fichIdGuid',
          '$_attr'
          )
        ''';
        }).join(',');
        http.Response response = await http.post(
          uriInsert,
          body: jsonEncode(<String, dynamic>{
            'query_string': '''
            UPDATE tbl_mg_order_fich SET 
            fich_total=$total,
            fich_nettotal=$total,
            fich_total_unit_amount=${cartItems.length},
            fich_modify_date=convert(datetime, GETDATE(), 104)
            where fich_id=$fichId;
            INSERT INTO tbl_mg_order_fich_line (
            fich_line_amount,
            fich_line_price,
            fich_line_total,
            inv_id,
            fich_id,
            material_id,
            fich_line_desc,
            unit_det_id,
            fich_line_disc_prc,
            fich_line_disc_amount,
            fich_line_nettotal,
            fich_line_date,
            service_id,
            fich_line_expiredate,
            fich_line_serialno,
            mat_inv_line_id,
            rep_rate,
            rep_total,
            fich_line_type_id,
            spe_code,
            group_code,
            security_code,
            fich_id_guid,
            spe_code1
          ) VALUES $values;
          ''',
          }),
        );
        if (response.statusCode == 200) {
          return {"fich_code": fichCode, "fich_id": fichId};
        }
        return null;
      }
    }
    return null;
  }

  Future<int> updateMaterialStatus(TblMgMaterials material, int statusId) async {
    final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
    var _devInfo = await _deviceInfoPlugin.androidInfo;
    String query = '''Update tbl_mg_materials
                      set a_status_id=$statusId, spe_code10=CAST(GETDATE() as NVARCHAR(20)) + ', LastChangedStatus=$statusId; BaseOs=${_devInfo.version.baseOS ?? ''}; Release=${_devInfo.version.release}; Brand=${_devInfo.brand}; Device=${_devInfo.device},Model=${_devInfo.model}, AndroidId=${await const AndroidId().getId() ?? ''}'
                      where material_id=${material.id}
                   ''';
    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.writeData(query);
            if (result != null) {
              return 1;
            } else {
              return 0;
            }
          }
          return 0;
        } catch (e) {
          debugPrint("Error updateMaterialStatus: ${e.toString()}");
        }
      }
    }
    return 0;
  }


  Future<int> changeOrderFichSalesman(int fichId, int salesmanId) async {
    final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
    var _devInfo = await _deviceInfoPlugin.androidInfo;
    String query = '''Update tbl_mg_order_fich
                      set salesman_id=$salesmanId, spe_code5=CAST(GETDATE() as NVARCHAR(20)) + ', LastChangedSalesmanId=$salesmanId; BaseOs=${_devInfo.version.baseOS ?? ''}; Release=${_devInfo.version.release}; Brand=${_devInfo.brand}; Device=${_devInfo.device},Model=${_devInfo.model}, AndroidId=${await const AndroidId().getId() ?? ''}'
                      where fich_id=$fichId
                   ''';
    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.writeData(query);
            if (result != null) {
              return 1;
            } else {
              return 0;
            }
          }
          return 0;
        } catch (e) {
          debugPrint("Error changeOrderFichSalesman: ${e.toString()}");
        }
      }
    }
    return 0;
  }

  Future<bool> closeOrders(
    List<CustomFichLine> fichlines,
    int fichId,
    int salesmanId,
    int whId,
  ) async {
    String query = "select * from tbl_mg_order_fich where fich_id = $fichId";
    if (dbConnectionSettings == 0) {
      if (serverAddress.isNotEmpty && serverPort.isNotEmpty && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        try {
          int connectionStatus = 1;
          if (!SqlConn.isConnected) {
            connectionStatus = await connect();
          }
          if (connectionStatus == 1) {
            var result = await SqlConn.readData(query);
            if (result != null) {
              String invCode = 'INV-' + DateTime.now().toString() + getRandomString(5);
              String fichCode = 'FICH-' + DateTime.now().toString() + getRandomString(5);
              String matTransLineCode = 'MTL-' + DateTime.now().toString() + getRandomString(5);

              List decoded = jsonDecode(result);
              TblMgOrderFich orderFich = TblMgOrderFich.fromMap(decoded[0]);
              String values = fichlines.map((e) {
                return '''
                    INSERT INTO tbl_mg_fich_line (
                      fich_line_amount,
                      fich_line_price,
                      fich_line_total,
                      inv_id,
                      fich_id,
                      material_id,
                      fich_line_desc,
                      unit_det_id,
                      fich_line_disc_prc,
                      fich_line_disc_amount,
                      fich_line_nettotal,
                      fich_line_date,
                      service_id,
                      fich_line_expiredate,
                      fich_line_serialno,
                      mat_inv_line_id,
                      mat_trans_line_id_in,
                      rep_rate,
                      rep_total,
                      fich_line_cost,
                      arap_id_vendor,
                      price_id,
                      fich_line_type_id,
                      spe_code,
                      group_code,
                      security_code,
                      inv_id_guid,
                      fich_id_guid,
                      fich_line_lot_number,
                      fich_line_lot_date,
                      lot_id_guid,
                      wh_id,
                      currency_id
                    ) values (
                      ${e.fichLineAmount},
                      ${e.fichLinePrice},
                      ${e.fichLineTotal},
                      @invId,
                      @fichId,
                      ${e.materialId},
                      '${e.fichLineDesc}',
                      1,
                      ${e.fichLineDiscPrc},
                      ${e.fichLineDiscAmount},
                      ${e.fichLineNettotal},
                      convert(datetime, '${e.fichLineDate.toString().replaceAll('Z', '')}'),
                      0,
                      convert(datetime, '1900-01-01 00:00:00.000'),
                      '',
                      0,
                      0,
                      0.000,
                      0.000,
                      0.000,
                      0,
                      0,
                      0,
                      '',
                      '',
                      '',
                      @invIdGuid,
                      @fichIdGuid,
                      '',
                      convert(datetime, '1900-01-01 00:00:00.000'),
                      '',
                      $whId,
                      0
                    )
                    SET @fich_line_id=SCOPE_IDENTITY()
                    SET @material_id=${e.materialId}
                    SET @wh_id=$whId
                    SET @mat_total_amount=(SELECT mat_whousetotal_amount FROM dbo.tbl_mg_material_total WITH (nolock) 
                      WHERE (material_id) = @material_id AND (wh_id=@wh_id))
                    INSERT INTO tbl_mg_mat_trans_line (
                      mat_trans_line_date,
                      material_id,
                      fich_line_id,
                      mat_inv_line_id,
                      arap_id,
                      mat_trans_type_id,
                      mat_trans_type_code,
                      mat_trans_line_amount_out,
                      mat_trans_line_price_out,
                      mat_trans_line_totalprice,
                      mat_trans_line_nettotal,
                      mat_trans_line_amount_in,
                      mat_trans_line_price_in,
                      mat_trans_line_totalprice_in,
                      mat_trans_line_nettotal_in,
                      mat_trans_line_wh_id_out,
                      mat_trans_line_wh_id_in,
                      mat_trans_line_wh_amount,
                      p_id,
                      fich_type_id,
                      mat_inv_type_id,
                      mat_trans_line_cdate,
                      unit_det_id,
                      mat_trans_line_wh_id_amount,
                      inv_real_code,
                      fich_line_expiredate,
                      mat_trans_line_id_out,
                      mat_trans_line_amount_in_onhand,
                      mat_trans_line_outcost,
                      mat_trans_line_retcost,
                      mat_trans_line_out_remain_amount,
                      rep_rate,
                      rep_currency_id
                    ) values (
                      convert(datetime, GETDATE(), 104),
                      @material_id, --material_id
                      @fich_line_id, --fich_line_id
                      0, 
                      ${orderFich.arapId}, --arap_id
                      1,
                      '$matTransLineCode', --mat_trans_type_code
                      ${e.fichLineAmount}, --mat_trans_line_amount_out
                      ${e.fichLinePrice}, --mat_trans_line_price_out
                      ${e.fichLineTotal}, --mat_trans_line_totalprice
                      ${e.fichLineNettotal}, --mat_trans_line_totalprice
                      0.0,
                      0.0,
                      0.0,
                      0.0,
                      @wh_id,
                      0,
                      @mat_total_amount,
                      1,
                      8,
                      0,
                      convert(datetime, GETDATE(), 104),
                      1,
                      @mat_total_amount,
                      NULL,
                      convert(datetime, '1900-01-01 00:00:00.000'),
                      0,
                      0.0,
                      0.0,
                      0.0,
                      0.0,
                      0.0,
                      0
                    )
                  ''';
              }).join('\n');

              var result2 = await SqlConn.writeData('''
                              DECLARE @saleDiscCardId int
                              SET @saleDiscCardId=(SELECT sale_disc_card_id FROM tbl_mg_sale_disc_cards where arap_id=${orderFich.arapId})
                  
                              INSERT INTO tbl_mg_invoice (
                              inv_code,
                              inv_date,
                              inv_total,
                              inv_create_date,
                              inv_type_id,
                              arap_id,
                              div_id,
                              dept_id,
                              plant_id,
                              wh_id,
                              p_id,
                              fich_id,
                              inv_desc,
                              inv_discount,
                              inv_nettotal,
                              salesman_id,
                              T_ID,
                              spe_code,
                              group_code,
                              security_code,
                              payplan_id,
                              inv_print_count,
                              acc_card_id,
                              ord_status_id,
                              inv_nettotal_text,
                              data_send,
                              rep_rate,
                              rep_total,
                              inv_approve_date,
                              sale_disc_card_id,
                              bank_acc_id,
                              delivery_arap_id,
                              sync_datetime,
                              modify_date
                            ) VALUES (
                              '$invCode',
                              convert(datetime, '${orderFich.fichDate.toString().replaceAll('Z', '')}'),
                              ${orderFich.fichTotal},--inv_total
                              convert(datetime, GETDATE(), 104),
                              8,--inv_type_id
                              ${orderFich.arapId},--arap_id
                              1,
                              1,
                              1,
                              $whId,--wh_id
                              1,
                              0,--fich_id
                              '',--fich_desc
                              ${orderFich.fichDiscount},
                              ${orderFich.fichNettotal},
                              $salesmanId,	
                              2010,
                              '${orderFich.speCode}',
                              '${orderFich.groupCode}',	
                              'Eltmek',
                              0,
                              0,
                              0,
                              1,
                              '', --inv_nettotal_text
                              0,
                              0.000,
                              0.000,
                              NULL,
                              @saleDiscCardId,--sale_disc_card_id
                              0,
                              0,
                              NULL,
                              convert(datetime, GETDATE(), 104)
                            )
                  
                            DECLARE @invId INT
                            SET @invId=SCOPE_IDENTITY()
                  
                            DECLARE @invIdGuid NVARCHAR(50)
                            SET @invIdGuid=(SELECT inv_id_guid FROM tbl_mg_invoice where inv_id=@invId)
                  
                            INSERT INTO tbl_mg_fich (
                              fich_code,
                              fich_date,
                              fich_total,
                              fich_create_date,
                              fich_type_id,
                              arap_id,
                              div_id,
                              dept_id,
                              plant_id,
                              wh_id,
                              p_id,
                              inv_id,
                              fich_desc,
                              fich_discount,
                              fich_nettotal,
                              salesman_id,
                              T_ID,
                              spe_code,
                              group_code,
                              security_code,
                              payplan_id,
                              rep_rate,
                              rep_total
                            ) VALUES (
                              '$fichCode',
                              convert(datetime, '${orderFich.fichDate.toString().replaceAll('Z', '')}'),
                              ${orderFich.fichTotal},--fich_total
                              convert(datetime, GETDATE(), 104),
                              8,--fich_type_id
                              ${orderFich.arapId},--arap_id
                              1,
                              1,
                              1,
                              $whId,--wh_id
                              1,
                              @invId,--inv_id
                              '',--fich_desc
                              ${orderFich.fichDiscount},
                              ${orderFich.fichNettotal},
                              2,	
                              2010,
                              '${orderFich.speCode}',
                              '${orderFich.groupCode}',	
                              'Eltmek',
                              0,
                              0.000,
                              0.000
                            )
                  
                            DECLARE @fichId INT
                            SET @fichId=SCOPE_IDENTITY()
                  
                            DECLARE @fichIdGuid NVARCHAR(50)
                            SET @fichIdGuid=(SELECT inv_id_guid FROM tbl_mg_invoice where inv_id=@fichId)
                  
                            UPDATE tbl_mg_invoice SET fich_id=@fichId WHERE inv_id=@invId
                  
                            DECLARE @material_id INT
                            DECLARE @wh_id INT
                            DECLARE @fich_line_id INT
                            DECLARE @mat_total_amount DECIMAL
                  
                            $values
                            
                            UPDATE tbl_mg_order_fich SET inv_id=@invId WHERE fich_id=$fichId
                            UPDATE tbl_mg_order_fich_line SET inv_id=@invId WHERE fich_id=$fichId''');
              if (result2 != null) {
                return true;
              }
              return false;
            }
          }
        } catch (e) {
          debugPrint("Error on QueryFromApi.closeOrders: ${e.toString()}");
        }
      }
    } else {
      Uri uriInsert = Uri.http(baseUrl, basePath, {cud: '1'});
      Uri uri = Uri.http(baseUrl, basePath);
      http.Response fich = await http.post(
        uri,
        body: jsonEncode(<String, dynamic>{
          'query_string': query,
        }),
      );
      if (fich.statusCode == 200) {
        String invCode = 'INV-' + DateTime.now().toString() + getRandomString(5);
        String fichCode = 'FICH-' + DateTime.now().toString() + getRandomString(5);
        String matTransLineCode = 'MTL-' + DateTime.now().toString() + getRandomString(5);
        String source = Utf8Decoder().convert(fich.bodyBytes);
        dynamic decoded = jsonDecode(source);
        List list = decoded['data'];
        TblMgOrderFich orderFich = TblMgOrderFich.fromMap(list[0]);
        String values = fichlines.map((e) {
          return '''
          INSERT INTO tbl_mg_fich_line (
            fich_line_amount,
            fich_line_price,
            fich_line_total,
            inv_id,
            fich_id,
            material_id,
            fich_line_desc,
            unit_det_id,
            fich_line_disc_prc,
            fich_line_disc_amount,
            fich_line_nettotal,
            fich_line_date,
            service_id,
            fich_line_expiredate,
            fich_line_serialno,
            mat_inv_line_id,
            mat_trans_line_id_in,
            rep_rate,
            rep_total,
            fich_line_cost,
            arap_id_vendor,
            price_id,
            fich_line_type_id,
            spe_code,
            group_code,
            security_code,
            inv_id_guid,
            fich_id_guid,
            fich_line_lot_number,
            fich_line_lot_date,
            lot_id_guid,
            wh_id,
            currency_id
          ) values (
            ${e.fichLineAmount},
            ${e.fichLinePrice},
            ${e.fichLineTotal},
            @invId,
            @fichId,
            ${e.materialId},
            '${e.fichLineDesc}',
            1,
            ${e.fichLineDiscPrc},
            ${e.fichLineDiscAmount},
            ${e.fichLineNettotal},
            convert(datetime, '${e.fichLineDate.toString().replaceAll('Z', '')}'),
            0,
            convert(datetime, '1900-01-01 00:00:00.000'),
            '',
            0,
            0,
            0.000,
            0.000,
            0.000,
            0,
            0,
            0,
            '',
            '',
            '',
            @invIdGuid,
            @fichIdGuid,
            '',
	          convert(datetime, '1900-01-01 00:00:00.000'),
	          '',
	          $whId,
	          0
          )
          SET @fich_line_id=SCOPE_IDENTITY()
          SET @material_id=${e.materialId}
          SET @wh_id=$whId
          SET @mat_total_amount=(SELECT mat_whousetotal_amount FROM dbo.tbl_mg_material_total WITH (nolock) 
            WHERE (material_id) = @material_id AND (wh_id=@wh_id))
          INSERT INTO tbl_mg_mat_trans_line (
            mat_trans_line_date,
            material_id,
            fich_line_id,
            mat_inv_line_id,
            arap_id,
            mat_trans_type_id,
            mat_trans_type_code,
            mat_trans_line_amount_out,
            mat_trans_line_price_out,
            mat_trans_line_totalprice,
            mat_trans_line_nettotal,
            mat_trans_line_amount_in,
            mat_trans_line_price_in,
            mat_trans_line_totalprice_in,
            mat_trans_line_nettotal_in,
            mat_trans_line_wh_id_out,
            mat_trans_line_wh_id_in,
            mat_trans_line_wh_amount,
            p_id,
            fich_type_id,
            mat_inv_type_id,
            mat_trans_line_cdate,
            unit_det_id,
            mat_trans_line_wh_id_amount,
            inv_real_code,
            fich_line_expiredate,
            mat_trans_line_id_out,
            mat_trans_line_amount_in_onhand,
            mat_trans_line_outcost,
            mat_trans_line_retcost,
            mat_trans_line_out_remain_amount,
            rep_rate,
            rep_currency_id
          ) values (
            convert(datetime, GETDATE(), 104),
            @material_id, --material_id
            @fich_line_id, --fich_line_id
            0, 
            ${orderFich.arapId}, --arap_id
            1,
            '$matTransLineCode', --mat_trans_type_code
            ${e.fichLineAmount}, --mat_trans_line_amount_out
            ${e.fichLinePrice}, --mat_trans_line_price_out
            ${e.fichLineTotal}, --mat_trans_line_totalprice
            ${e.fichLineNettotal}, --mat_trans_line_totalprice
            0.0,
            0.0,
            0.0,
            0.0,
            @wh_id,
            0,
            @mat_total_amount,
            1,
            8,
            0,
            convert(datetime, GETDATE(), 104),
            1,
            @mat_total_amount,
            NULL,
            convert(datetime, '1900-01-01 00:00:00.000'),
            0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0
          )
        ''';
        }).join('\n');
        http.Response response = await http.post(
          uriInsert,
          body: jsonEncode(<String, dynamic>{
            'query_string': '''
            DECLARE @saleDiscCardId int
            SET @saleDiscCardId=(SELECT sale_disc_card_id FROM tbl_mg_sale_disc_cards where arap_id=${orderFich.arapId})

            INSERT INTO tbl_mg_invoice (
            inv_code,
            inv_date,
            inv_total,
            inv_create_date,
            inv_type_id,
            arap_id,
            div_id,
            dept_id,
            plant_id,
            wh_id,
            p_id,
            fich_id,
            inv_desc,
            inv_discount,
            inv_nettotal,
            salesman_id,
            T_ID,
            spe_code,
            group_code,
            security_code,
            payplan_id,
            inv_print_count,
            acc_card_id,
            ord_status_id,
            inv_nettotal_text,
            data_send,
            rep_rate,
            rep_total,
            inv_approve_date,
            sale_disc_card_id,
            bank_acc_id,
            delivery_arap_id,
            sync_datetime,
            modify_date
          ) VALUES (
            '$invCode',
            convert(datetime, '${orderFich.fichDate.toString().replaceAll('Z', '')}'),
            ${orderFich.fichTotal},--inv_total
            convert(datetime, GETDATE(), 104),
            8,--inv_type_id
            ${orderFich.arapId},--arap_id
            1,
            1,
            1,
            $whId,--wh_id
            1,
            0,--fich_id
            '',--fich_desc
            ${orderFich.fichDiscount},
            ${orderFich.fichNettotal},
            $salesmanId,	
            2010,
            '${orderFich.speCode}',
            '${orderFich.groupCode}',	
            'Eltmek',
            0,
            0,
            0,
            1,
            '', --inv_nettotal_text
            0,
            0.000,
            0.000,
            NULL,
            @saleDiscCardId,--sale_disc_card_id
            0,
            0,
            NULL,
            convert(datetime, GETDATE(), 104)
          )

          DECLARE @invId INT
          SET @invId=SCOPE_IDENTITY()

          DECLARE @invIdGuid NVARCHAR(50)
          SET @invIdGuid=(SELECT inv_id_guid FROM tbl_mg_invoice where inv_id=@invId)

          INSERT INTO tbl_mg_fich (
            fich_code,
            fich_date,
            fich_total,
            fich_create_date,
            fich_type_id,
            arap_id,
            div_id,
            dept_id,
            plant_id,
            wh_id,
            p_id,
            inv_id,
            fich_desc,
            fich_discount,
            fich_nettotal,
            salesman_id,
            T_ID,
            spe_code,
            group_code,
            security_code,
            payplan_id,
            rep_rate,
            rep_total
          ) VALUES (
            '$fichCode',
            convert(datetime, '${orderFich.fichDate.toString().replaceAll('Z', '')}'),
            ${orderFich.fichTotal},--fich_total
            convert(datetime, GETDATE(), 104),
            8,--fich_type_id
            ${orderFich.arapId},--arap_id
            1,
            1,
            1,
            $whId,--wh_id
            1,
            @invId,--inv_id
            '',--fich_desc
            ${orderFich.fichDiscount},
            ${orderFich.fichNettotal},
            2,	
            2010,
            '${orderFich.speCode}',
            '${orderFich.groupCode}',	
            'Eltmek',
            0,
            0.000,
            0.000
          )

          DECLARE @fichId INT
          SET @fichId=SCOPE_IDENTITY()

          DECLARE @fichIdGuid NVARCHAR(50)
          SET @fichIdGuid=(SELECT inv_id_guid FROM tbl_mg_invoice where inv_id=@fichId)

          UPDATE tbl_mg_invoice SET fich_id=@fichId WHERE inv_id=@invId

          DECLARE @material_id INT
          DECLARE @wh_id INT
          DECLARE @fich_line_id INT
          DECLARE @mat_total_amount DECIMAL

          $values
          
          UPDATE tbl_mg_order_fich SET inv_id=@invId WHERE fich_id=$fichId
          UPDATE tbl_mg_order_fich_line SET inv_id=@invId WHERE fich_id=$fichId
          ''',
          }),
        );
        if (response.statusCode == 200) {
          return true;
        }
        return false;
      }
    }
    return false;
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
