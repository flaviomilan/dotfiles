require('lspconfig').jdtls.setup {
  settings = {
    java = {
      configuration = {
        runtimes = {
          {
            name = 'JavaSE-21',
            path = '/opt/jdk-21',
            default = true,
          },
        },
      },
    },
  },
}
