const Router = require('express');
const geraBkp = require('./geraBkp');

// import all controllers
// import SessionController from './app/controllers/SessionController';

const routes = new Router();

// Add routes
routes.get('/', ((req, res) => res.send('Seja bem vindo a API')));
routes.get('/email', ((req, res) => {
    console.log("api ativada")
    geraBkp().then(data => {
        console.log("Email enviado com sucesso")
        res.send("Email enviado com sucesso")
    })
}));
// routes.post('/', SessionController.store);
// routes.put('/', SessionController.store);
// routes.delete('/', SessionController.store);


module.exports = routes
