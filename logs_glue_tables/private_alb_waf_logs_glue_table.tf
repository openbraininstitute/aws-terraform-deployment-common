resource "aws_glue_catalog_table" "waf_logs" {
  name          = var.waf_table_name
  database_name = aws_glue_catalog_database.web_logs.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    "EXTERNAL"                  = "TRUE"
    "projection.enabled"        = "true"
    "projection.year.type"      = "integer"
    "projection.year.range"     = "2024,2040"
    "projection.month.type"     = "integer"
    "projection.month.range"    = "1,12"
    "projection.month.digits"   = "2"
    "projection.day.type"       = "integer"
    "projection.day.range"      = "1,31"
    "projection.day.digits"     = "2"
    "projection.hour.type"      = "integer"
    "projection.hour.range"     = "0,23"
    "projection.hour.digits"    = "2"
    "projection.minute.type"    = "integer"
    "projection.minute.range"   = "0,59"
    "projection.minute.digits"  = "2"
    "storage.location.template" = "s3://${var.waf_logs_bucket}/AWSLogs/${local.account_id}/WAFLogs/${local.region}/private-alb-waf/$${year}/$${month}/$${day}/$${hour}/$${minute}"
  }

  partition_keys {
    name = "year"
    type = "int"
  }
  partition_keys {
    name = "month"
    type = "int"
  }
  partition_keys {
    name = "day"
    type = "int"
  }
  partition_keys {
    name = "hour"
    type = "int"
  }

  partition_keys {
    name = "minute"
    type = "int"
  }

  storage_descriptor {
    location      = "s3://${var.waf_logs_bucket}/AWSLogs/${local.account_id}/WAFLogs/${local.region}/private-alb-waf/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
    }

    columns {
      name = "timestamp"
      type = "bigint"
    }
    columns {
      name = "formatversion"
      type = "int"
    }
    columns {
      name = "webaclid"
      type = "string"
    }
    columns {
      name = "terminatingruleid"
      type = "string"
    }
    columns {
      name = "terminatingruletype"
      type = "string"
    }
    columns {
      name = "action"
      type = "string"
    }
    columns {
      name = "terminatingrulematchdetails"
      type = "array<struct<conditiontype:string,sensitivitylevel:string,location:string,matcheddata:array<string>>>"
    }
    columns {
      name = "httpsourcename"
      type = "string"
    }
    columns {
      name = "httpsourceid"
      type = "string"
    }
    columns {
      name = "rulegrouplist"
      type = "array<struct<rulegroupid:string,terminatingrule:struct<ruleid:string,action:string,rulematchdetails:array<struct<conditiontype:string,sensitivitylevel:string,location:string,matcheddata:array<string>>>>,nonterminatingmatchingrules:array<struct<ruleid:string,action:string,rulematchdetails:array<struct<conditiontype:string,sensitivitylevel:string,location:string,matcheddata:array<string>>>>>,excludedrules:string>>"
    }
    columns {
      name = "ratebasedrulelist"
      type = "array<struct<ratebasedruleid:string,limitkey:string,maxrateallowed:int>>"
    }
    columns {
      name = "nonterminatingmatchingrules"
      type = "array<struct<ruleid:string,action:string,rulematchdetails:array<struct<conditiontype:string,sensitivitylevel:string,location:string,matcheddata:array<string>>>>>"
    }
    columns {
      name = "requestheadersinserted"
      type = "array<struct<name:string,value:string>>"
    }
    columns {
      name = "responsecodesent"
      type = "string"
    }
    columns {
      name = "httprequest"
      type = "struct<clientip:string,country:string,headers:array<struct<name:string,value:string>>,uri:string,args:string,httpversion:string,httpmethod:string,requestid:string>"
    }
    columns {
      name = "labels"
      type = "array<struct<name:string>>"
    }
    columns {
      name = "captcharesponse"
      type = "struct<responsecode:string,solvetimestamp:string>"
    }
  }
}
