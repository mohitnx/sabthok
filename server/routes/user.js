const express = require("express");
const userRouter = express.Router();
const auth = require("../middlewares/auth");
const Order = require("../models/order");
const { Product } = require("../models/product");
const User = require("../models/user");


//add to cart

//very eeassssy , see all commetbs very easy to understand
userRouter.post("/api/add-to-cart", auth, async (req, res) => {
    try {
        //req.body ma client side bata we will send id of produvt
        //then find a prduct that matches that id and store it in product
      const { id } = req.body;
      const product = await Product.findById(id);
      //due to auth , we can find the user who made the request, and assign it to user, 
      let user = await User.findById(req.user);
            //cart is one of the properites of user like name, password, address etc
      if (user.cart.length == 0) {
        //empty cart, so qunatity will be 1 for the first item in cart
        //cart is a arry, so we can push in it by this way
        user.cart.push({ product, quantity: 1 });
        //case for when there are items already in cart
        //if it is the same prduct, then we have to just increase teh quantity
        //if it is a new product we have to make quantity 1, and add teh product also
      } else {
        let isProductFound = false;
        for (let i = 0; i < user.cart.length; i++) {
            //cart[i] means ith postn ma bhako cart item, then we look at its id through product._id ( remember mngoDd gives a unique id for every item in the databse)
            //here we are getting the unique id of product (.prodct._id) cha, and not of user, remember
            //Product is also a model notjust a schema, so we can get Product ko _id 

            //we are chekcing if productid at ith posn is equal to the product provided from req.body ko id
            //if yes, then it is smae product, just increate the product quantitty
            //if no then push product, and make quantitiy 1

            //here in product._id we could have uesd const{id}=req.body, ko id, it would have been same,
            //just note in that case we would need user.cart[i].product._id.toString() as _id is not string by defalut; it is ObjctId, which is a combinatio of string and int
            //for the same reason we can't use == and have to use equals()
            //just chekng each product id in users cart to the product id proviede while makeing this post request from client side
          if (user.cart[i].product._id.equals(product._id)) {
            isProductFound = true;
          }
        }
        

        //if it is a product that is already there, 
        if (isProductFound) {
            //.find()=> means find something that matchse the criterai defiend after teh arrow func
            //which is  productt.product._id.equals(product._id) here 

            //here producttt will find user.cart items, thenthat  ko product property ko id we access, 
          let producttt = user.cart.find((productt) =>
          //producttt.product._id user.cart.product._id
            productt.product._id.equals(product._id)
          );
          //now producttt is user.cart item rememnber, so we can get its quantit and increae
          producttt.quantity += 1;
        } else {
            //if new product
          user.cart.push({ product, quantity: 1 });
        }
      }
      //since we updated ther cart property of user, so we need to save it
      user = await user.save();
      res.json(user);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });





//remove from cart

userRouter.delete("/api/remove-from-cart/:id", auth, async (req, res) => {
  try {
    //similar to const id = req.params.id
    //but we know in js, if argument and paramet both have same names, use culry and wirte name once like below
    const { id } = req.params;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);

    for (let i = 0; i < user.cart.length; i++) {
      if (user.cart[i].product._id.equals(product._id)) {
        //if quanrity already one,then decreasing qill remove teh product entirely
        if (user.cart[i].quantity == 1) {
          //splice will delete 1 element from ith posn
       //so 1 qunaty of a product, then just remove that product from the list of producets of that usre
       //which is what we aer doing, user.cart.splice, measns, cart list bata remove one itme/product
          user.cart.splice(i, 1);
        } else {
          //else just decrease teh qunatity by one 
          user.cart[i].quantity -= 1;
        }
      }
    }
    user = await user.save();
    console.log(user);
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//storing the user address
userRouter.post("/api/save-user-address", auth, async (req, res) => {
  try {
    const { address } = req.body;
    let user = await User.findById(req.user);
    //user ko address block ma we sae the address passed by api call
    user.address = address;
    //since address property is modifed, we save teh user
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


//order product
userRouter.post("/api/order", auth, async (req, res) => {
  try {
    const { cart, totalPrice, address } = req.body;
    let products = [];

    for (let i = 0; i < cart.length; i++) {
      let product = await Product.findById(cart[i].product._id);
      //checjing if we have product stock....if order 10 and we have 5 then we cant sell
      if (product.quantity >= cart[i].quantity) {
        //we have to reduce the amount that id oredered from total stock of the product
        product.quantity -= cart[i].quantity;
        products.push({ product, quantity: cart[i].quantity });
        await product.save();
      } else {
        return res
          .status(400)
          .json({ msg: `${product.name} is out of stock!` });
      }
    }

    let user = await User.findById(req.user);
    user.cart = [];
    user = await user.save();

    let order = new Order({
      products,
      totalPrice,
      address,
      userId: req.user,
      orderedAt: new Date().getTime(),
    });
    order = await order.save();
    res.json(order);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


//getting user orders 
userRouter.get("/api/orders/me", auth, async (req, res) => {
  try {
    const orders = await Order.find({ userId: req.user });
    res.json(orders);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//ordering 



module.exports = userRouter;