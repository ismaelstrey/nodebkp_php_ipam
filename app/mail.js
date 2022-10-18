var nodemailer = require('nodemailer');

var mail = nodemailer.createTransport({
    host: "smtp.umbler.com",
    port: 587,
    secure: false,
    auth: {
        user: 'ismael@coreinfra.com.br',
        pass: ''
    }
});

const enviarEmail = async (arquivo) => {
    var mailOptions = {
        from: 'ismael@coreinfra.com.br',
        to: 'ismaelstrey@hotmail.com',
        subject: 'Email enviado via API NODE',
        text: 'Envio de bakp de MYSQL do PHPIPAM',
        attachments: [{   // utf-8 string as an attachment
            path: arquivo
        }]
    };
    const enviar = await mail.sendMail(mailOptions, function (error, info) {
        if (error) {
            console.log(error);
        } else {
            console.log('Email enviado com sucesso: ' + info.response);
        }
    });
    return enviar
}
module.exports = enviarEmail
