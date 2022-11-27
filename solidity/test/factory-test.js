var Factory = artifacts.require('./TicketFactory.sol')

contract('Voter', function(accounts) {
    let firstAccount;
    let factory;

    beforeEach(async function() {
        firstAccount = accounts[0];
        factory = await Factory.new();
        await factory.setMessage('top top top top, yes, yes, yes, yes', {from: firstAccount});
    });

    it('message is set', async function() {
        let message = await factory.message.call();

        expect(message).to.equal('top top top top, yes, yes, yes, yes')
    })

    // it('failing', async function() {
    //     try {
    //         await factory.message.call();
    //         expect.fail();
    //     } catch (error) {
    //         expect(error.message).to.equal('Error message');
    //     }
    // })
})