const express = require('express');
const productRouter = express.Router();
const auth = require('../middlewares/auth');
const {Product} = require('../models/product');

//../ for going out of the folder, ./ for going out of the file


//getting info from the url itself
//two ways

//we already knkow params wala way, 
//1. api/products:category=Essentails
//then we can use req.params.category

//2. api/products?category=Essentials
//then we can use req.query.category

productRouter.get('/api/products', auth, async(req,res)=>{
    try{
        
       const products = await Product.find({category:req.query.category}); 
       res.json(products);
   
    }catch(e)
    {
       res.status(500).json({error: e.json});
    }
   });


   productRouter.get('/api/products/search/:name', auth, async(req,res)=>{
    try{
        //due to regex, if we search i in search bar, we get eveything beginning from i
        //we could do like name: req.params.name only but then it would show iphone if we type iphone only, not i 
       const products = await Product.find({
        //i means case insensitive
        //this is basically what we did in sqfile for searching based on substring, 
        //so req.parsm.name ma jun substring cha, if it exists it willshow up
        //eg: antoher is title then if we search oth, or er, her, etc, it will show up...and it is case insensitive
        name: {$regex: req.params.name, $options: "i"}}); 
       res.json(products);
   
    }catch(e)
    {
       res.status(500).json({error: e.json});
    }
   });


// rating product
productRouter.post('/api/rate-product/', auth, async(req,res)=>{
   try{
       
     const {id, rating} = req.body;
     //let instead of const as we need to change rating
     //findById is going to give us a product, that prduct will have a list of {userId, rating} assocaited with it as each user will give thier own rating to the same product

     let product = await Product.findById(id);

     //LOGICCCC////
   //.findBy will find a product based on its id, 
   //so we will have one Product as id is unique
   //then inside that product, we various properties like name, descruption, etc
   //among that one of the property is our ccustom raitngsSchema, 
   //ratingsSchema further has userId and rating, so we can then check the user(as they have been authentivated, so we
   //have their id, and go and change their specific rating)
      //possible result or above findById
      //{
      //userId: 'aa5'
      //rating: 3.5,

    //userId: 'aa2'
      //rating: s.5,

          //userId: '331'
      //rating: 4.5,

          //userId: 'dfs'
      //rating:5,
     // }
     

     //so we loop through this and select the rating where userId matches the id provided to us
     //then we can access the rating by product.rating, and change it, remove it
     console.log(product.ratings.length);
     for (let i =0; i < product.ratings.length; i++)

     {
      //this ratings[i] is refering to one item of => {userId:'ss', ratings:3.5} 
      // this product.ratings[i] is similar to product.name, product.description, 
      console.log('12');
      //since only authenticated users can makke ratings, we alrady have thier id(due to the auth middleware) but how???? (ans: both middleware and this post req have access to req,res ani uta auth ma we have put req.user ko value) which we can access using just req.user
       if(product.ratings[i].userId == req.user)
       {
         //we can use splice for many things, google it for more
         //here we are saying, frm posin i in array delete 1 item so since prdocut.ratings is a list
         //we are removing one item at nth posn 
         //and as said above, see Product ko model in product.js, an item here is a map of userId, rating
         product.ratings.splice(i,1);
         break;
       }
     }

     console.log('2');
     //adding a new item to product.ratings which includes the new raing, which was the point of this whole thing
     const raitngsSchema = {
      userId: req.user,
     rating,
     }
     console.log('3');
     product.ratings.push(raitngsSchema);
     product = await product.save();
     res.json(product);
  
   }catch(e)
   {
      res.status(500).json({error: e.json});
   }
  });

  


  //product of the day route


  //whichever product has the highest rating is going to be the deal of the day product
  productRouter.get("/api/deal-of-day", auth, async (req, res) => {
   try {
     let products = await Product.find({});
 //withuot (a,b), sort fuction will just sort in ascndng order, but with (a,b) , it will sort based on the fucntion definded by the => function
 //a= product1, b=product2 first compare those two, then move forwared then a=procut2, b=product3 and so on
 //it will first find the sum of total ratings(store it in aSum and bSum), and sort in desceding order
 //so that deal of the day/ product with hightes elemnt, will be the first elemnet, and we can send that to the user side

 //sort returns a sorted arary, so storing the array in the same lcation of the original array
      products = products.sort((a, b) => {
       let aSum = 0;
       let bSum = 0;
 
       for (let i = 0; i < a.ratings.length; i++) {
         //aSum will hold total ratings of product1
         aSum += a.ratings[i].rating;
       }
 
       for (let i = 0; i < b.ratings.length; i++) {
         //bSum will hold ttotal rains of pruct2
         bSum += b.ratings[i].rating;
       }
       //returns holds the condn based on which it will sort
       //if we return aSum > bSum ? 1 : -1;, then product with highest rating will be the last element of array
       //-1 means product 1 is less than scond, 1 means vice versa, 0 means equal 
       //a less than b(pro1 less than pro 2) so return 1, so b takes precidence 
       return aSum < bSum ? 1 : -1;
     });
     //by the time sort ends here, we have the product with highest rating in first place in the array, so just send that
     
     res.json(products[0]);
   } catch (e) {
     res.status(500).json({ error: e.message });
   }
 });


module.exports = productRouter;