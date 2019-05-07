const success = 'success'
const store = weex.requireModule('storage')

export let storage = {}

storage.getItem = (key, callback) => {
  store.getItem(key, e => {
    let isSuccess = e.result === success
    let data = e.data

    if (data === 'undefined') {
      isSuccess = false
    }
    callback(isSuccess, e.data)
  })
}

storage.setItem = (key, value, callback) => {
  if (value === undefined || value === null || value.length === 0) {
    store.removeItem(key, e => {
      const result = e.result === success

      if (callback !== undefined) {
        callback(result)
      }
    })
  } else {
    store.setItem(key, value, e => {
      const isSuccess = e.result === success
      console.log(key, isSuccess, ':', e.data)
      if (callback !== undefined) {
        callback(isSuccess)
      }
    })
  }
}

storage.token = (callback) => {
  storage.getItem('zzzl_token', callback)
}

storage.setToken = (token, callback) => {
  storage.setItem('zzzl_token', token, callback)
}

storage.setName = (name, callback) => {
  storage.setItem('zzzl_name', name, callback)
}

storage.name = (callback) => {
  storage.getItem('zzzl_name', callback)
}

storage.setPassword = (password, callback) => {
  storage.setItem('zzzl_password', password, callback)
}

storage.password = (callback) => {
  storage.getItem('zzzl_password', callback)
}

storage.setDevicePassword = (mid, password, callback) => {
  storage.setItem('zzzl_device_password' + mid, password, callback)
}

storage.devicePassword = (mid, callback) => {
  storage.getItem('zzzl_device_password' + mid, callback)
}
