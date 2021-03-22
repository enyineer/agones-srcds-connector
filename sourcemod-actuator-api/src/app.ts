import express from 'express'
import { Application } from 'express'

export class App {
    public app: Application
    public port: number

    constructor(opts: { port: number; middlewares: any; controllers: any; }) {
        this.app = express()
        this.port = opts.port

        this.middlewares(opts.middlewares)
        this.routes(opts.controllers)
    }

    private middlewares(middlewares: { forEach: (arg0: (middleWare: any) => void) => void; }) {
        middlewares.forEach(middleWare => {
            this.app.use(middleWare)
        })
    }

    private routes(controllers: { forEach: (arg0: (controller: any) => void) => void; }) {
        controllers.forEach(controller => {
            this.app.use('/', controller.router)
        })
    }

    public listen() {
        this.app.listen(this.port, () => {
            console.log(`App listening on http://localhost:${this.port}`)
        })
    }
}
