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
            WHERE username='${req.body.username}'
        `
        const dataRes=(param1, param2, param3, param4)=>{
            return {
                checkUsername:param1,
                checkPassword:param2,
                idUser:param3,
                notification:param4
            }
        }
        const data=await client.query(query)
        console.log(data.rows)
        if(data.rows[0]){
            if(data.rows[0].password==req.body.password){
                res.send(dataRes(true,true,data.rows[0].id,"Đăng nhập thành công"))
            }else{
                res.send(dataRes(true,false,null,"Sai mật khẩu"))
            }
        }else{
            res.send(dataRes(false,false,null,"Tài khoản không tồn tại"))
        }
    },
    changePassword:async (req,res)=>{
        const dataReq=req.body
        const queryChangePassword=`
            UPDATE users SET password='${dataReq.newPassword}'
            WHERE id='${req.headers.id_user}'
        `
        const queryGetPassword=`
            SELECT * FROM users
            WHERE id='${req.headers.id_user}'
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