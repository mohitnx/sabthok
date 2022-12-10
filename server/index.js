const express = require('express');
const mongoose = require('mongoose');

const PORT = process.env.PORT || 8000;
const app = express();

const DB = 'mongodb+srv://mohit:RuhSvh8epzAdGKJ@cluster0.w2ad6me.mongodb.net/?retryWrites=true&w=majority';

const adminRouter = require('./routes/admin.js');
const authRouter = require('./routes/auth');
const productRouter = require('./routes/product.js');
const userRouter = require('./routes/user.js');









//express.json is a builtin middleware that parses all incoming json requests and puts the parsed data in req.body
//.use to use middleware
app.use(express.json());
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);




mongoose.connect(DB)
.then(()=>{
    console.log('connceted to mongodb');
}).catch((e)=>{
console.log(e);
});


//to avoid NO ROUTE TO HOST error
//while testing from actual device, both server(laptop) and phone should be in same 
//network and we should specify the laptops/servers ip instead of localhost or 127.0.0.1

app.listen(PORT, ()=>{
    
    console.log(`connceted at port tt ${PORT}`);
});

