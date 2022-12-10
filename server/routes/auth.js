const express = require('express');
const User = require('../models/user');
const bcryptjs =  require("bcryptjs");
const authRouter = express.Router();
const jwt = require("jsonwebtoken");
const auth = require("../middlewares/auth");



//signUP, post request

authRouter.post('/api/signup', async(req, res)=>{
    try{
        //we send json from userside after encoding teh class obj dart into json file, 
        //then that json reaches here, and express.json gets it and parses it and stores
        //the parsed data in req.body, then we can access the req.body (here a map)
        //by destructureing
        const{email, name, password, address, type} = req.body;
        
        const existingUser = await User.findOne({email});
        
        if(existingUser)
        {
            return res.status(400).json({msg: "User with this email already exists!"});
        }


        //hashing pw, so that if mongodb is compromized, hackers won't get to see acutal pw
        const hashedPassword = await bcryptjs.hash(password, 8);

        let user = new User({
            email,
            password: hashedPassword,
            name, 
            address,
            type,
        })
        //saving to db
        user = await user.save();
        console.log(user);
        res.json(user);

    }catch(e)
    {
        res.status(500).json({error: e.message});
    }
});



//login user

authRouter.post("/api/signin", async (req, res)=>{
    try{
        const {email, password}= req.body;
        const user = await User.findOne({email});
        if(!user){
            return res.status(400).json({msg: "User with this email doesn't exist"});
        }
      

        //toask: salt use garera even the same string entered two times will have two diff hashed pw, so how can we compare 
        //a string and its correspoing hashed value here??
   
        
        //compare method compares password sotred in db with the pw supplied by user while loggin in
        //bcrypt uses blowfish cipher for hasing
        const isMatch = await bcryptjs.compare(password, user.password);
        if (!isMatch){
            return res.status(400).json({msg: "Incorrect password"});
        }
        //we use jwt to check if the users are who they say they are ???
        //we use token to persist state, so if a user is logged in we save their token aand vased on that
        //we can display homepage or login/signup pge

        
      const token =  jwt.sign({id: user._id}, "passwordKey");
     //token is a looong string of characetrs, each of our user object gets assigned with a token
        //we don't need to do token:token for obvious reasons
     res.json({token, ...user._doc});
      //why user._doc used and why user._id used?
      //ans: tried in thunder client without adding ._doc, looks like its just formattting
      //and id ko value is in user_.id
      
      // withut ._doc, it gives many others thins in json response like state, require, default, inint, k k ho k k 
      //'...' will add token:'tokenValue' to name:'moit' , 'email':'sjsjsj'  , so basically it will add token:token to ther user part while sending the json, so in the same json we can have all thoses things inside the same map as just described
      //so signin ko post requst ko response ma aba token bhanne propery ni ayo
      
    }
   
    catch(e)
    {
        res.status(500).json({error: e.message});
    }
});

///////////////////////////////////////////////////////////
//validating token from jwt


authRouter.post('/tokenIsValid', async(req,res)=>{

    try{
        //when we send this post requset from client side, tesko header ma we send the token   we have for verification
        //x-auth-token is the key and tesko correspoding value is token
        //now based on the token we respoknd with true or false(true if valid, faslse if empty(' ')or invalid)
            const token = req.header('x-auth-token');


            //we send false as we just want to know is the token is present or not for now..
            //if false then there is no token
            if (!token) return res.json(false);
            //if it is true, then we verify if the provided token is valid or not
            //verify method helps with verification, teti yaad garne
          const verified =  jwt.verify(token, "passwordKey");
            if(!verified) return res.json(false); //if not verifed then verifed variable won't have value , so return false
            //now we have reached here, meaning teh token is valid
            //now we check if a user exists for that particula token //a token is a random string of charactes, 
            //so there is some sliiight chance that a token a exist purely by coincidence, 
            //so we are verifiying there is a user for that conrrespdoiging token



           
            //whole jwt, sharedPreference wala bujeko chaina ramrari
            const user = await User.findById(verified.id); 
            if(!user) return res.json(false);
            //finally if we reach here means, a token exists, and it is a token of an acutal usr, so we can say isTokenValid? true
            res.json(true);

    }catch(e)
    {
        res.status(500).json({error: 'token validation failed'});
    }
});


/////////////////////////////////////////////////////////////////////////
//getting user DAta

////////////
// here as we know while making routes, we can also pass middleware, now this middleware auth will 
// make sure that we have access to this .get route if we are signed ins


authRouter.get('/', auth, async(req, res)=>
{
  //we get req.user from the auth middleware that we have created
  const user = await User.findById(req.user);
  res.json({...user._doc, token: req.token});
  //user of ... and ._doc is already mentioned 
});

module.exports = authRouter;