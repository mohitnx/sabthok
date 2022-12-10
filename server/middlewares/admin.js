const jwt = require('jsonwebtoken');
const User = require('../models/user');

const admin = async (req, res, next)=>  {

try{
    //authorization is done by admin middleware which looks at header
    const token = req.header('x-auth-token');
    if(!token)
    //401 error means no access
    return res.status(401).json({msg: 'No auth token, Access Denined'});
    const verifed = jwt.verify(token, "passwordKey");
    if (!verifed) return res.status(401).json({msg: 'Token Verification Failed, Access Denined'});
    //if we are here means we have got verified 
    const user = await User.findById(verifed.id);
    //now we check if the user is admin or not, if not we display 401 error
    if(user.type=='user' || user.type == 'seller'){
        return res.status(401).json({msg:"Unauthorized Access Denied! You aren't an admin"});
    }
    //if we are here menas, the user trying to access is admin
    req.user = verifed.id;
    req.token = token;
    next();
}
catch(e){
    res.status(500).json({error: err.message});
}
}

module.exports = admin;