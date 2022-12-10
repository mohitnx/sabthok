const jwt = require('jsonwebtoken');


const auth = async(req, res, next) => {
    try{
        const token = req.header('x-auth-token');
        if(!token)
        //in js !token means there is no value there, so empty/ there is no token present, access denied
        //401 error means no access
        return res.status(401).json({msg: 'No auth token, Access Denined'});
        //if token is present then we can verfiy it
        const verifed = jwt.verify(token, "passwordKey");
        //if not verfied then also access denined
        if (!verifed) return res.status(401).json({msg: 'Token Verification Failed, Access Denined'});
        
        req.user = verifed.id;
        req.token = token;
        
        next();
    }
    catch(e){  
        res.status(500).json({error: err.message});
    }
}

module.exports = auth;