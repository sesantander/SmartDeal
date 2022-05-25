App = {
  loading: false,
  contracts: {},
  
  load: async () => {
    await App.loadWeb3()
    await App.loadAccount()
    await App.loadContract()
    await App.render()
  },

  loadWeb3: async () => {
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider
      web3 = new Web3(web3.currentProvider)
    } else {
      window.alert("Please connect to Metamask.")
    }
    if (window.ethereum) {
      window.web3 = new Web3(ethereum)
      try {
        await ethereum.enable()
        web3.eth.sendTransaction({/* ... */})
      } catch (error) {
      }
    }
    else if (window.web3) {
      App.web3Provider = web3.currentProvider
      window.web3 = new Web3(web3.currentProvider)
      web3.eth.sendTransaction({/* ... */})
    }
    else {
      console.log('Non-Ethereum browser detected. You should consider trying MetaMask!')
    }
  },

  loadAccount: async () => {
    // Cargamos la direccion conectada en metamask
    App.account = web3.eth.accounts[0]
  },
  loadContract: async () => {
    // Obtenemos una el smart contract 
    const contract = await $.getJSON('ContractSC.json')
    const proposalContract = await $.getJSON('ProposalSC.json')
    const transactionContract = await $.getJSON('TransactionSC.json')
    const invoiceContract = await $.getJSON('InvoiceSC.json')

    App.contracts.Contract = TruffleContract(contract)
    App.contracts.ProposalContract = TruffleContract(proposalContract)
    App.contracts.TransactionContract = TruffleContract(transactionContract)
    App.contracts.InvoiceContract = TruffleContract(invoiceContract)

    web3.eth.defaultAccount = web3.eth.accounts[0];

    App.contracts.Contract.setProvider(App.web3Provider)
    App.contracts.ProposalContract.setProvider(App.web3Provider)
    App.contracts.TransactionContract.setProvider(App.web3Provider)
    App.contracts.InvoiceContract.setProvider(App.web3Provider)

    App.contract = await App.contracts.Contract.deployed()
    App.ProposalContract = await App.contracts.ProposalContract.deployed()
    App.TransactionContract = await App.contracts.TransactionContract.deployed()
    App.InvoiceContract = await App.contracts.InvoiceContract.deployed()
  },
  
  render: async () => {
    if (App.loading) {
      return
    }
    App.setLoading(true)
    // Renderizamos la cuenta
    $('#account').html(App.account)
    // Renderizamos el balance del smart contract
    let balance = await App.contract.showBalance()
    $('#balance').html( `Smart Contract Balance : ${balance?.c[0]/10000}.00 ETH`)
    // Renderiuzamos las tareas
    await App.renderTasks()

    App.setLoading(false)
  },

  renderTasks: async () => {
    // Llamamos la variable taskCount del smart contract que va a tener el total de tareas
    const taskCount = await App.contract.contractCount()
    const proposalCount = await App.ProposalContract.proposalCount()
    const transactionCount = await App.TransactionContract.transactionCount()
    const invoiceCount = await App.InvoiceContract.invoiceCount()
    const $taskTemplate = $('.taskTemplate')
    
    const transactionAddress = await App.TransactionContract.getAddress();
    console.log('LOG ~ renderTasks: ~ transactionAddress', transactionAddress)

    const paymethod = await App.contract.pay(1,transactionAddress, "24/05/2022", "24/05/2022");
    console.log('LOG ~ renderTasks: ~ paymethod', paymethod)


    //  const getCpmtract = await App.contract.getContract(1);
    //  console.log('LOG ~ renderTasks: ~ getCpmtract', getCpmtract[1])


// for (var i = 1; i <= proposalCount; i++) {
//       const propo = await App.ProposalContract.proposals(i);
//       console.log('LOG ~ renderTasks: ~ PROPOSALS', propo)
// }
console.log('LOG ~ renderTasks: ~ transactionCount', transactionCount)
for (var i = 1; i <= transactionCount; i++) {
      const xd = await App.TransactionContract.transactions(i);
      console.log('LOG ~ renderTasks: ~ Transactions', xd)
}
// for (var i = 1; i <= invoiceCount; i++) {
//       const xd = await App.InvoiceContract.invoices(i);
//       console.log('LOG ~ renderTasks: ~ Invoices', xd)
// }
    for (var i = 1; i <= taskCount; i++) {
      // Obtenemos el array de tareas del smart contract
      const task = await App.contract.contracts(i)
      const task2 = await App.contract.contracts_details(i)

      console.log('LOG ~ renderTasks: ~ task', task)
      console.log('LOG ~ renderTasks: ~ task', task2)

      const taskId = task[0].toNumber()
      const taskContent = task[1]
      const taskCompleted = task[2]
      const taskReward = task2[2].toNumber()

      // Llenamos el html con la informacion de cada tarea
      const $newTaskTemplate = $taskTemplate.clone()
      $newTaskTemplate.find('.content').html(taskContent + ' - ' + taskReward + " ETH")
      $newTaskTemplate.find('input')
                      .prop('name', taskId)
                      .prop('checked', taskCompleted)
                      .on('click', App.marked)

      if (taskCompleted) {
        $('#completedTaskList').append($newTaskTemplate)
      } else {
        $('#taskList').append($newTaskTemplate)
      }

      $newTaskTemplate.show()
    }
  },
  depositEth: async () => {
    // Metodo para enviar ether de una cuenta a otra, en este caso enviamos ether a la direccion de el smart contract
    await web3.eth.sendTransaction({
      from: App.account,
      to: '0x0cda18B7C9952ef4DF502c8D59435B1c3226438F', 
      value: web3.toWei(201, "ether"), 
    }, async function(err, transactionHash) {
        if (err) { 
            console.log("Error: ",err); 
        } else {
            console.log("Transaction Hash", transactionHash);
        }
    });

  },
  createTask: async () => {
    App.setLoading(true)
    const content = $('#newTask').val()
    const rewardValue = $('#reward').val()

    // Una vez obtenidos los valores ingresados por el usuario creamos la tarea con el metodo de el smart contract
    await App.contract.createContract("Termino indefinido", "Test Contract 2", "Frontend Developer", "Disagree","5 buttons","13/05/2022","20/05/2022","USD", 1333, "Monthly", "30", 1, 1, 1)

    window.location.reload()
  },

  marked: async (e) => {
    App.setLoading(true)
    const taskId = e.target.name
    // Obtenemos el valor del reward de la tarea con taskId
    let rewardValue = await App.contract.getTaskReward(taskId)
    // Marcamos la tarea como completa
    await App.contract.markCompleted(taskId)
    // Enviamos ether con el valor de la recompensa a la cuenta conectada
    await App.contract.sendEther(App.account, rewardValue)
    
    window.location.reload()
  },

  setLoading: (boolean) => {
    App.loading = boolean
    const loader = $('#loader')
    const content = $('#content')
    if (boolean) {
      loader.show()
      content.hide()
    } else {
      loader.hide()
      content.show()
    }
  }
}

$(() => {
  $(window).load(() => {
    App.load()
  })
})