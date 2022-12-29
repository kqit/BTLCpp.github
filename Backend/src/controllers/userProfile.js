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
                ('pr${req.headers.id_user}','${dataReq.fullName}','${dataReq.weight}','${dataReq.height}','${dataReq.sex}','${dataReq.age}','${dataReq.address}','${dataReq.avatar}')
        `
        
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
    updateUserProfile:async(req,res)=>{
        dataReq=req.body
        dataReq.itemChange.forEach(item => {
            const querySetUserProfile=`
            UPDATE profile SET ${item}='${dataReq[`${item}`]}'
            WHERE id_profile='pr${req.headers.id_user}'
        `
            client.query(querySetUserProfile,(err)=>{
                if(err){
                    console.log(err)
                    res.send({
                        status:false
                    })
                }else{
                    res.send({
                       status:true 
                    })
                }
            })
        });    
    }
}
module.exports=userProfile