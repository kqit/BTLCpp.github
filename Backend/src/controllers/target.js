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
        const idUser=req.headers.id_user
        const queryCheckTarget=`
            SELECT * FROM target
            WHERE id_target='ta${idUser}' AND times='${dataReq.times}'
        `
        const queryCreateTarget=`
            INSERT INTO target(id_target, calo, cacbohydrate, protein, lipit, times)
            VALUES ('ta${idUser}','${dataReq.calo}','${dataReq.cacbohydrate}','${dataReq.protein}','${dataReq.lipit}','${dataReq.times}')
        `
        const checkTarget= await client.query(queryCheckTarget)
        if(!checkTarget.rowCount){
            client.query(queryCreateTarget,(err)=>{
                if(err){
                    console.log(err)
                }else{
                    res.send({
                        status:true
                    })
                }
            })
        }    
    },
    changeTarget: async(req,res)=>{
        const dataReq=req.body
        const idUser=req.headers.id_user
        const queryCheckTarget=`
            SELECT * FROM target
            WHERE id_target='ta${idUser}' AND times='${dataReq.times}'
        `
        const queryChangeTarget=`
            UPDATE target SET
                calo='${dataReq.calo}', 
                cacbohydrate='${dataReq.cacbohydrate}',
                protein='${dataReq.protein}', 
                lipit='${dataReq.lipit}'
            WHERE id_target='ta${idUser}' AND times='${dataReq.times}'
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