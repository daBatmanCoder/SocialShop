import iArnaconSDK

class Web3Manager {
    static let shared = Web3Manager()

    var web3Service: Web3IS?
    var publicKey: String?

    private init() {
        let dataSaveHelper = UserDefaultsDataSaveHelper()
        let logger = ConsoleLogger()
        web3Service = Web3IS(_dataSaveHelper: dataSaveHelper, _logger: logger)
        publicKey = web3Service?.WALLET.getPublicKey()

    }
}
