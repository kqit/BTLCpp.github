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
const schedule={
    createTag:async(req,res)=>{
        const dataReq=req.body
        const idUser=req.headers.id_user
        const now=new Date()
        const idSchedule='sc'+idUser
        const idSession=idSchedule+dataReq.session.slice(0,2)+now.getDate()+now.getMonth()+now.getFullYear()
        const idTag=idSession+dataReq.id_food
        const queryCreateTag=`
            INSERT INTO tag(id_tag, id_food, mass)
            VALUES
                ('${idTag}','${dataReq.id_food}','${dataReq.mass}')
        `
        const queryCreateSession=`
            INSERT INTO session(id_session, id_tag)
            VALUES
                ('${idSession}','${idTag}')
        `
        const queryCreateSchedule=`
            INSERT INTO schedule(id_schedule,id_session)
            VALUES
                ('${idSchedule}','${idSession}')
        `
        const queryCheckSession=`
            SELECT * FROM schedule
            WHERE id_session='${idSession}' 
        `
        const queryCheckTag=`
            SELECT * FROM session
            WHERE id_tag='${idTag}'
        `
        const dataCheckSession=await client.query(queryCheckSession)
        if(!dataCheckSession.rowCount){
            client.query(queryCreateSchedule,async (err)=>{
                if(err){
                    console.log(err)
                    res.send({
                        status:false,
                        notification:"Lỗi tạo schedule"
                    })
                }else{
                    client.query(queryCreateSession,(err)=>{
                        if(err){
                            res.send({
                                status:false,
                                notification:"Lỗi tạo session"
                            })
                        }else{
                            client.query(queryCreateTag,(err)=>{
                                if(err){
                                    res.send({
                                        status:false,
                                        notification:"Lỗi tạo tag"
                                    })
                                }else{
                                    res.send({
                                        status:true
                                    })
                                }
                            })
                        }
                    })
                }
            })
        }else{
            const dataCheckTag=await client.query(queryCheckTag)
            if(!dataCheckTag.rowCount){
                client.query(queryCreateSession,(err)=>{
                    if(err){
                        console.log(err)
                    }else{
                        client.query(queryCreateTag)
                    }
                })
            }else{
                client.query(queryCreateTag)
            }
        }
        
    },
    getSession:async(req,res)=>{
        const dataReq=req.body
        const idUser=req.headers.id_user
        const queryGetIdSchedule=`
            SELECT * FROM users
            WHERE id='${idUser}'
        `
        const data=await client.query(queryGetIdSchedule)
        if(data){
            const listData=await data.rows
            listData.forEach(async(element) => {
                const queryGetIdSession=`
                SELECT * FROM schedule
                WHERE id_schedule='${element.id_schedule}' AND times='12/27/2022'
            `
                const data1=await client.query(queryGetIdSession)
                if(data1){
                    IdSession=()=>{
                        let x
                        data1.rows.forEach((element)=>{
                            if(dataReq.session=="morning"&&element.id_session.includes("mo")) x=element
                            if(dataReq.session=="afternoon"&&element.id_session.includes("af")) x=element
                            if(dataReq.session=="night"&&element.id_session.includes("ni")) x=element
                            
                        })
                        return x.id_session
                    }
                    const queryGetTag=`
                        SELECT id_tag FROM session
                        WHERE id_session='${IdSession()}'
                        `
                    console.log(IdSession())
                    const result=(await client.query(queryGetTag)).rows
                    console.log(result)
                    let dataRes=[]
                    result.forEach(async (item)=>{
                        const queryGetTag=`
                            SELECT id_food, mass FROM tag
                            WHERE id_tag='${item.id_tag}'
                        `
                        const dataTag=await client.query(queryGetTag)
                        const queryCalo=`
                            SELECT name,calo_per_100gr FROM food
                            WHERE id_food='${dataTag.rows[0].id_food}'
                        `
                        const chitiet=await client.query(queryCalo)
                        console.log(chitiet.rows)
                        dataRes=[...dataRes,{id_tag:item.id_tag,...dataTag.rows[0],...chitiet.rows[0]}]
                        if(dataRes.length==result.length){
                            res.send({
                                status:true,
                                data:dataRes
                            })
                        }
                          
                    })                   
                }
            });
        }
    },
    getTag:async(req,res)=>{
        const dataReq=req.body
        const idTag=dataReq.id_tag
        const queryGetTag=`
            SELECT * FROM tag
            WHERE id_tag='${idTag}'
        `
        const dataTag= await client.query(queryGetTag)
        if(dataTag.rows[0]){
            const queryFood=`
                SELECT * FROM food
                WHERE id_food='${dataTag.rows[0].id_food}'
            `
            const dataFood=(await client.query(queryFood)).rows[0]
            if(dataFood){
                res.send({
                    status:true,
                    mass:dataTag.rows[0].mass,
                    data:dataFood
                })
            }else{
                res.send({
                    title:"ngu",
                    status:false
                })
            }
        }else{
            res.send({
                status:false
            })
        }
    },
    updataTag:async(req,res)=>{
        const dataReq=req.body
        const queryUpdateTag=`
            UPDATE tag SET mass=${dataReq.newMass} WHERE id_tag='${dataReq.id_tag}'
            
        `
        client.query(queryUpdateTag,(err)=>{
            if(err){
                res.send({status:false})
            }else{
                res.send({
                    status:true
                })
            }
        })
    },
    deletaTag:async(req,res)=>{
        const dataReq=req.body
        const idTag=dataReq.id_tag
        const queryDeleteTag=`
                DELETE FROM tag WHERE id_tag='${idTag}'
        `
        client.query(queryDeleteTag,(err)=>{
            if(err){
                res.send({status:false})
            }else{
                res.send(
                    {status:true}
                )
            }
        })
    }
}
module.exports=schedule