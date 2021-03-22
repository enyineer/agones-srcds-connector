export class AgonesService {
    private static instance: AgonesService;

    private constructor() {}

    public static getInstance(): AgonesService {
        if (this.instance === undefined) {
            this.instance = new AgonesService();
        }
        return this.instance;
    }

}