module.exports = {
  networks: {
    genache: {
      host: '127.0.0.1',
      port: 7545,
      gas: 5000000,
      network_id: '*' // Matches any network id
    }
  },
  compilers: {
    solc: {
      version: "0.8.13",              
      optimizer: {
        enabled: true,
        runs: 1,
      },
    },
 }
};