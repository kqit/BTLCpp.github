const { Client }= require('pg')
const client=new Client(
    {
        user: 'postgres',
        host: 'localhost',
        database: 'Calories',
        password: '123456',
        port: 5432,
    }
)
client.connect()
const nutritionLookup={
    search:async(req,res)=>{
        const dataReq=req.query
        console.log(dataReq)
        const queryGetData=`
            SELECT * FROM food
            WHERE name LIKE '%${dataReq.searchLetter}%' LIMIT ${dataReq.limit}
        `
        const data=await client.query(queryGetData)
        if(data.rows[0]){
            console.log(data.rows)
            res.send({
                status:true,
                searchResult:data.rows
            })
        }else{
            res.send({
                status:false
            })
        }
    },
    getFood:async(req,res)=>{
        const queryData=`
            SELECT * FROM food LIMIT ${req.query.limit}
        `
        console.log(req.query.limit)
        data = await client.query(queryData)
        if(data.rows[0]){
            res.send({
                status:true,
                data:data.rows
            } 
        )
        }else{
            res.send({
                status:false
            })
        }
    }
}
module.exports=nutritionLookup