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
const  userAuthentication={
    signUp:async(req,res)=>{
        const dataReq=req.body
        const checkUsername=`
            SELECT * FROM users
            WHERE username='${dataReq.username}'
        `
        console.log(dataReq)
        const checkUsernameDB=client.query(checkUsername)
        if((await checkUsernameDB).rows[0]){
            res.send({
                signupStatus:false,
                notification:"Tên người dùng đã tồn tại"
            })
        }else{
            const now=new Date()
            const id=`${now.getDate()}`+now.getMonth()+now.getMinutes()+now.getSeconds()
            const query=`
                INSERT INTO users(id, username, password, id_profile, id_target, id_schedule)
                VALUES
                ('${id}','${dataReq.username}','${dataReq.password}','pr${id}','ta${id}','sc${id}')
            `
            await client.query(query,(err)=>{
                if(err){
                    console.log(err)
                }else{
                    res.send({
                        signupStatus:true,
                        notification:"Đăng kí thành công"
                    })
                }
            })
        }  
    },
    logIn:async(req,res)=>{
        const query=`
            SELECT * FROM users
            WHERE username='${req.headers.username}'
        `
        const dataRes=(param1, param2,param3)=>{
            return {
                idUser:param1,
                status:param2,
                notification:param3
            }
        }
        const data=await client.query(query)
        console.log(data.rows)
        if(data.rows[0]){
            if(data.rows[0].password==req.headers.password){
                res.send(dataRes(data.rows[0].id,true,"Đăng nhập thành công"))
            }else{
                res.send(dataRes(null,false,"Sai mật khẩu"))
            }
        }else{
            res.send(dataRes(null,false,"Tài khoản không tồn tại"))
        }
    },
    changePassword:async (req,res)=>{
        const dataReq=req.body
        const queryChangePassword=`
            UPDATE users SET password='${dataReq.newPassword}'
            WHERE id='${req.headers.idUser}'
        `
        const queryGetPassword=`
            SELECT * FROM users
            WHERE id='${req.headers.idUser}'
        `
        const dataDB=await client.query(queryGetPassword)
        if(dataReq.password===dataDB.rows[0].password){
            client.query(queryChangePassword)
            res.send({
                status:true,
                notifaiction:"Thay đổi thành công"
            })
        }else{
            res.send({
                status:false,
                notification:"Mật khẩu cũ không đúng"
            })
        }
    }
}
module.exports=userAuthentication