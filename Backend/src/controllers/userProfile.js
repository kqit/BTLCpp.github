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
const userProfile={
    createUserProfile:async(req,res)=>{
        dataReq=req.body
        const queryCreateProfile=`
            INSERT INTO profile(id_profile, full_name, weight, height, sex, age, address, avatar)
            VALUES
                ('pr${req.headers.idUser}','${dataReq.fullName}','${dataReq.weight}','${dataReq.height}','${dataReq.sex}','${dataReq.age}','${dataReq.address}','${dataReq.avatar}')
        `
        console.log(dataReq)
        await client.query(queryCreateProfile,(err)=>{
            if(err){
                console.log(err)
                res.send({
                    status:false
                })
            }else{
                res.send({status:true})
            }
        })    
    },
    getUserProfile: async(req,res)=>{
        const idUser=req.headers.iduser
        const query=`
            SELECT * FROM profile
            WHERE id_profile='pr${idUser}'
        `
        
        const dataProfile=await client.query(query)
        if(dataProfile.rowCount){
        
            res.send({
                status:true,
                data:dataProfile.rows[0] 
            })
        }else{
            res.send({
                status:false,
                data:{}
            })
        }
    },
    updateUserProfile:async(req,res)=>{
        dataReq=req.body
        const querySetUserProfile=`
            UPDATE profile SET ${dataReq.itemChange}='${dataReq.newValue}'
            WHERE id_profile='pr${req.headers.iduser}'    `
        console.log(dataReq)
            client.query(querySetUserProfile,(err)=>{
                if(err){
                    console.log("error")
                    res.send({
                        status:false
                    })
                }else{
                    console.log("ok")
                    res.send({
                       status:true 
                    })
                }
            })
           
    }
}
module.exports=userProfile