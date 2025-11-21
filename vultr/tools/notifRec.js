const { Api, TelegramClient } = require('telegram');
const { NewMessage } = require('telegram/events');
const { StoreSession } = require('telegram/sessions');
const input = require('input');
const delay = require('delay');
const fs = require('fs');

// Server
const serv = 'Vultr';
const wait = 15; // in minute
const bot_id = 'temposerv_bot';
// All Message New
const servs = [];
let mess = {};
// Current Filename
const fileName = __filename.substring(__dirname.length + 1, __filename.lastIndexOf('.'));
if(!fs.existsSync(`./session`)){
    fs.mkdirSync(`./session`);
};
// Client
const api = 7713038;
const hash = '987fb7123654e39d10ac24e177b8b704';
let chat = 285810888; // Will be updated to bot's ID
const sess = `./session/${fileName}WD`;
const storeSession = new StoreSession(sess);

// Start Script
(async () => {
    try{
        // Create Time each Server
        if(servs.length > 0){for(let x = 0; x < servs.length; x++){mess[servs[x]] = 0}};
        if(!fs.existsSync(`./${fileName}.json`)){
            const formatted_config = JSON.stringify(mess, null, 4);
            fs.writeFileSync(`./${fileName}.json`, formatted_config, 'utf8');
        };
        console.log('Loading Client Telegram...');
        const client = new TelegramClient(storeSession, api, hash, {
            connectionRetries: 10,
        });
        await client.start({
            phoneNumber: async () => await input.text('Please enter your number: '),
            password: async () => await input.text('Please enter your password: '),
            phoneCode: async () => await input.text('Please enter the code you received: '),
            onError: (err) => console.log(err),
        });
        client.session.save();
        console.log('You should now be connected.');
        // Get the bot's entity and set chat to its ID
        const botEntity = await client.getEntity(bot_id);
        chat = botEntity.id;
        console.log(`Bot chat ID: ${chat}`);
        async function eventPrint(event) {
            mess = JSON.parse(fs.readFileSync(`./${fileName}.json`, 'utf8'));
            const message = event.message;
            const text = message.text;
            if (!text) return; // Skip non-text messages
            mess[text] = message.date * 1000;
            console.log(`The message is: ${text}`);
            console.log(`The date is: ${new Date(mess[text])}`);
            const formatted_config = JSON.stringify(mess, null, 4);
            fs.writeFileSync(`./${fileName}.json`, formatted_config, 'utf8');
            for(let x of Object.keys(mess)){
                if((parseFloat(Date.now()) - parseFloat(mess[x]) > wait * 60000) && parseFloat(mess[x]) != 0){
                    await client.invoke(
                        new Api.messages.SendMessage({
                            peer: 'edonez',
                            message: `Server ${x} is Off, Check it Now ...`
                        })
                    );
                };
            };
            await fetch(`https://api.telegram.org/bot8573549118:AAEdKAGmvlCiskq5VwfT-so4NX2_xtHiV3I/sendMessage?text=Server%20${serv}%20for%20Notification%20Receiver%20is%20Running%20...&chat_id=277081400`);
            console.log(`Sent Notif Server ...`);
        };
        // Fetch the last message and process it
        try {
            const lastMessages = await client.getMessages(chat, { limit: 1 });
            if (lastMessages.length > 0) {
                const mockEvent = { message: lastMessages[0] };
                await eventPrint(mockEvent);
            }
        } catch (err) {
            console.log('Error fetching last message:', err);
        }
        // await fetch(`https://api.telegram.org/bot6506982300:AAGm-cuJMfQN1cv9ljXEOemNX7ww2OJ7VQY/sendMessage?text=${serv}&chat_id=285810888`);
        // Add event handler for new messages
        client.addEventHandler(async (event) => {
            console.log(`Received new message from ${event.message.chatId}: ${event.message.text}`);
            await eventPrint(event);
        }, new NewMessage({ chats: [chat] }));
        
        console.log('Listening for new messages...');
        // Keep the process running indefinitely to listen for messages
        process.stdin.resume();
    }catch(err){
        let e = 1;
        if(err['errorMessage'] === 'FLOOD'){
            await fetch(`https://api.telegram.org/bot8573549118:AAEdKAGmvlCiskq5VwfT-so4NX2_xtHiV3I/sendMessage?text=Server%20${serv}%20Tele%20Flood%20Begin%20...&chat_id=277081400`);
            for(let x = 0; x <= parseInt(err['seconds']); x++){
                await delay(1000);
                console.log(`Waiting Flood ${e} of ${err['seconds']}`);
                e++;
            };
            await fetch(`https://api.telegram.org/bot8573549118:AAEdKAGmvlCiskq5VwfT-so4NX2_xtHiV3I/sendMessage?text=Server%20${serv}%20Tele%20Flood%20End%20...&chat_id=277081400`);
            await fetch(`https://api.telegram.org/bot6506982300:AAGm-cuJMfQN1cv9ljXEOemNX7ww2OJ7VQY/sendMessage?text=${serv}&chat_id=${chat}`);
        }else{
            await fetch(`https://api.telegram.org/bot8573549118:AAEdKAGmvlCiskq5VwfT-so4NX2_xtHiV3I/sendMessage?text=Server%20${serv}%20Error%20check%20it%20Out%20...&chat_id=277081400`);
            console.log(`Sent Error Notif Server ...`);
            await delay(wait * 60000);
        };
    };
})();