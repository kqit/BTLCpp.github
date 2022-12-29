const express=require('express')
const { Client } = require('pg')
const morgan=require('morgan')
const BodyParser=require('body-parser')
const dotevn=require('dotenv')
const routers=require('./routers/index.js')


dotevn.config()
const app=express()
app.use(BodyParser.json())
app.use(BodyParser.urlencoded({extended:true}))
app.use(morgan('combined'))
app.use(express.static('public'))
app.use('/',routers)

app.listen(5000,()=>{
    console.log("server is run")
})