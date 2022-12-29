const nutritionLookup = require('../controllers/nutritionLookup')
const schedule = require('../controllers/schedule')
const target = require('../controllers/target')
const userAuthentication=require('../controllers/userAuthentication')
const userProfile = require('../controllers/userProfile')
const router=require('express').Router()

router.post('/signup',userAuthentication.signUp)
router.get('/login',userAuthentication.logIn)
router.put('/changepassword',userAuthentication.changePassword)
router.post('/createprofile',userProfile.createUserProfile)
router.put('/updateprofile',userProfile.updateUserProfile)
router.get('/nutritionlookup',nutritionLookup.search)
router.post('/createschedule',schedule.createTag)
router.get('/getsession',schedule.getSession)
router.get('/gettag',schedule.getTag)
router.put('/updatetag',schedule.updataTag)
router.delete('/deletetag',schedule.deletaTag)
router.post('/createtarget',target.createTarget)
router.put('/changetarget',target.changeTarget)

module.exports=router