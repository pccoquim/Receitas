import nodemailer from 'nodemailer';

const sendEmail = async (to, subject, html) => {
    const transporter = nodemailer.createTransport({
        host: 'smtp.sapo.pt',
        port: 465,
        secure: true, // usa SSL
        auth: {
            user: process.env.EMAIL_USER,
            pass: process.env.EMAIL_PASS,
        },
    });

    await transporter.sendMail({
    from: '"Receitas App" <paulo.coquim1@sapo.pt>',
    to,
    subject,
    html,
    });
};

export default sendEmail;
