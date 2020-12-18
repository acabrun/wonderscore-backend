// import express and co
require('dotenv').config();
const express = require('express');
const router = require('./app/router');
const session = require('express-session');

// creating server
const app = express();

// -------------------------------------------------------
// -------------------- MIDDLEWARE -----------------------
// -------------------------------------------------------

// adding middleware for handle body for post request
app.use(express.urlencoded({extended: true}));

// middleware for handle session
app.use(session({
    //mot de passe servant à crypter les infos
    secret: 'my super secret passphrase',
    //va sauvegarder une nouvelle session même si elle n'est pas modifiée
    saveUninitialized: true,
    //resauvegarde une session à chaque requête même sans modif (pas de date d'expiration)
    resave: true
}));


// middleware for handle formadata body from post request
const multer = require('multer');
const bodyParser = multer();

// we use .none() for tell only regular input (no file)
app.use( bodyParser.none() );

// adding middleware for handle JSON body
app.use(express.json());

app.use((_, res, next) => {
    // use it only for dev. For prod, set only website allowed
    res.setHeader('Access-Control-Allow-Origin', '*');
    next();
})

// adding middleware for disabled cors policy
const cors = require('cors');
app.use(cors());

// -------------------------------------------------------
// ---------------- END OF MIDDLEWARE --------------------
// -------------------------------------------------------

// use router file
app.use(router);

// starting server
const PORT = process.env.PORT;
app.listen(PORT, () => {
    console.log(`Server listening on ${PORT}`)
});








