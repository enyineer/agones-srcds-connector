import { App } from './app'

import bodyParser from 'body-parser'
import loggerMiddleware from './middleware/logger'
import { EventsController } from './controllers/eventsController'

const app = new App({
    port: 3000,
    controllers: [
        new EventsController()
    ],
    middlewares: [
        bodyParser.json(),
        bodyParser.urlencoded({ extended: true }),
        loggerMiddleware
    ]
})

app.listen()
