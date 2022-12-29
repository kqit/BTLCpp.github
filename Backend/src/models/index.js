const {Client }= require('pg')
const queryTableUser=require('./user')
const queryTableProfile=require('./profile')
const queryTableSchedule=require('./schedule')
const queryTableTag=require('./tag')
const queryTableTarget=require('./target')
const queryTableTask=require('./session')
const queryTableFood = require('./food')
const queryTableSession = require('./session')
const client=new Client(
    {
        user: 'postgres',
        host: 'localhost',
        database: 'Calories',
        password: '123456',
        port: 5432,
    }
)
client.connect((err)=>{
    if (err) {
        console.log(err)
    }else{
        console.log("ket noi thanh cong")
    }
})

const createTable=(query)=>{   
    client.query(query,(err,res)=>{
        if(err){
            console.log(err)
        }else{
            console.log("Tạo bảng thành công")
        }
    })
}
//createTable(queryTableUser)
//createTable(queryTableProfile)
//createTable(queryTableSchedule)
//createTable(queryTableSession)
createTable(queryTableTarget)
//createTable(queryTableTag)
//createTable(queryTableFood)






