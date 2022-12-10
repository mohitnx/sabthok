const express = require('express');
const adminRouter = express.Router();
const admin = require('../middlewares/admin');
//while exporting we expored {Product, productScema}, so to access Product, we again need curly braces
const {Product} = require('../models/product');

//adding product
//note: we can add as many middlewares as we want, here we have only one called as admin
//authorization is done by admin middleware which looks at header, data is passed through body
adminRouter.post('/admin/add-product', admin, async(req,res)=>{
    try{
        const {name, description, images, quantity, price, category} = req.body;
        let product = new Product({
            name, description, images, quantity, price, category

        });
   //selling prpduct will hold the response we have from .sae func from mongdb
   //and we are sending that response back as res.json
     let   sellingProduct = await product.save();
     console.log(sellingProduct);
        res.json(sellingProduct);
    }

    //error occured here
    catch(e)
    {
        res.status(500).json({error: e.message})
    ;}
});




//getting all the products from mongoose, this is also only availbae to admins, so admin middleware used here too
//in mongoose there is image link instead of actual imges, the acutal image is hosted in cloudinary

adminRouter.get('/admin/get-products', admin, async(req,res)=>{
 try{
    //if we just use find({}), then it will find all teh things
    const products = await Product.find({}); 
    res.json(products);

 }catch(e)
 {
    res.status(500).json({error: e.json});
 }
});

//deleting products
adminRouter.post('/admin/delete-product', admin, async(req,res)=>{
    try{
        const {id} = req.body;
       let product = await Product.findByIdAndDelete(id); 
       //saving the updated list in the database after deleting
     
    
       res.json(product);
       
   
    }catch(e)
    {
       res.status(500).json({error: e.json});
    }
   });

module.exports = adminRouter;
//we improt it at index.js