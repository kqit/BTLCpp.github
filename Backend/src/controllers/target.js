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
const target={
    createTarget:async(req,res)=>{
        const dataReq=req.body
        const idUser=req.headers.iduser
        const queryCheckTarget=`
            SELECT * FROM target
            WHERE id_target='ta${idUser}'
        `
        const queryCreateTarget=`
            INSERT INTO target(id_target, calo, cacbohydrate, protein, lipit)
            VALUES ('ta${idUser}','${dataReq.calo}','${dataReq.cacbohydrate}','${dataReq.protein}','${dataReq.lipit}')
        `
        console.log(idUser);
        console.log(dataReq)
        const checkTarget= await client.query(queryCheckTarget)
        if(!checkTarget.rowCount){
            client.query(queryCreateTarget,(err)=>{
                if(err){
                    
                }else{
                    res.send({
                        status:true
                    })
                }
            })
        }    
    },
    getTarget: async(req,res)=>{
        const dataReq=req.headers
        const queryData=`
            SELECT * FROM target 
            WHERE id_target='ta${dataReq.iduser}'
        `
        const data=await client.query(queryData)
        if(data.rows[0]){
            console.log(data.rows[0])
            res.send({
                status:true,
                data:data.rows[0]
            })
        }
    },
    changeTarget: async(req,res)=>{
        const dataReq=req.body
        const idUser=req.headers.iduser
        const queryCheckTarget=`
            SELECT * FROM target
            WHERE id_target='ta${idUser}'
        `
        const queryChangeTarget=`
            UPDATE target SET
                calo='${dataReq.calo}', 
                cacbohydrate='${dataReq.cacbohydrate}',
                protein='${dataReq.protein}', 
                lipit='${dataReq.lipit}'
            WHERE id_target='ta${idUser}'
        `
        console.log(dataReq)
        const checkTarget= await client.query(queryCheckTarget)
        if(checkTarget.rowCount){
            client.query(queryChangeTarget,(err)=>{
                if(err){
                    res.send({
                        status:false,
                    })
                }else{
                    res.send({
                        status:true
                    })
                }
            })
        }
    }
}
module.exports=target