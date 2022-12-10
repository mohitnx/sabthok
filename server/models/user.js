const mongoose = require("mongoose");
const { productSchema } = require("./product");


//Schema != to model, if we just make a schema, a collection in its name wont be added to mongodb
//we can create a model by taking this schema, then a collecdtion based on this schema is created in mongodb
//we can create a model using mmongoose.model(modelname, schema)
const userSchema = mongoose.Schema({
    
    name: {
        requred: true,
        type: String, 
        trim: true,
     
        
    },
    email: {
        required: true,
        type: String,
        trim: true,
           //if error in validation occurs, then mongoose throws its own msg:
        //" 'modelName' validation failed:variable:message: "
        //here User is the model name, varibale is email and message is Please enter a valid email addresss
        //so msg thrown in snackbar is : User validatio failed:email: Please enter a vaid email addresssss
        validate: {
            validator: (value)=>{
                const re =   /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
                //condn and return statement in the same line
                return value.match(re);
            },
            //t
            //if not valid/ doesn't match teh regex expression, this error messgae is showwn
            message: "Please enter a valid email address",
        },
    },
    //this password validation will fail as we ahve encryptied our password before sending to mongodb
    //so even if we enter a pw less than 6 lenght, due to hashing and encruption , it will be more than 6..so it will always validate
    
    password: {
        required: true,
        type: String,
        trim: true,
        // validate: {
        //     validator: (value) =>{
        //             return value.length >5;
        //     },
        //     message: "Enter at least 6 digits for password",
        // },
       
    },
    //note if any filed is not required, we can pass a default value of ' ' to it
    address: {
        type: String,
       
    },
    
    type: {
        type: String,
        
    },
   
    cart: [
       {    
        //product will be of type productSchema, quantity will be of type Number
        product: productSchema,
        quantity: {
            type: Number, 
            required: true,
        }

        },
    ],
});



//creating a model by providing a model name and the schema it follows
//mongoose.model(<Collectionname>, <CollectionSchema>)

//Collection name comes when validation fails: User validation failed:Users:messaeg
const User = mongoose.model('User', userSchema);
//making User model avalibale throughout the folder
module.exports = User;