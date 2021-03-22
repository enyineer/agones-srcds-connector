import * as express from 'express'
import { Request, Response } from 'express'
import { IControllerBase } from '../interfaces/controllerBase.interface';

export class EventsController implements IControllerBase {
    public path = '/'
    public router = express.Router()

    constructor() {
        this.initRoutes()
    }

    public initRoutes() {
        this.router.post('/events/mapStart', this.mapStart);
        this.router.post('/events/mapEnd', this.mapEnd);
        this.router.post('/events/gameStart', this.gameStart);
        this.router.post('/events/gameEnd', this.gameEnd);
    }

    private mapStart(req: Request, res: Response) {
        res.status(200).send({});
    }

    private mapEnd(req: Request, res: Response) {
        res.status(200).send({});
    }

    private gameStart(req: Request, res: Response) {
        res.status(200).send({});
    }

    private gameEnd(req: Request, res: Response) {
        res.status(200).send({});
    }
}