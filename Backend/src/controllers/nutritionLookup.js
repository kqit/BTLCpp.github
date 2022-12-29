const {Client }= require('pg')
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
        const dataReq=req.body
        const queryGetData=`
            SELECT * FROM food
            WHERE name LIKE '%${dataReq.searchWord}%'  
        `
        const data=await client.query(queryGetData)
        if(data.rows[0]){
            res.send({
                status:true,
                searchResult:data.rows
            })
        }else{
            res.send({
                status:false
            })
        }
    }
}
module.exports=nutritionLookup