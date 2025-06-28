import dotenv from 'dotenv'
import express from 'express'
import next from 'next'
import path from 'path'
import payload from 'payload'

import { seed } from './payload/seed'

dotenv.config({
  path: path.resolve(__dirname, '../.env'),
})

const app = express()
const PORT = process.env.PORT || 3000

const start = async (): Promise<void> => {
  const mongoURL = process.env.DATABASE_URI
  if (!mongoURL) {
    console.error('❌ DATABASE_URI is not set. Please check your .env or Railway env vars.')
    process.exit(1)
  }

  await payload.init({
    secret: process.env.PAYLOAD_SECRET || 'developmentSecret',
    mongoURL,
    express: app,
    onInit: () => {
      payload.logger.info(`✅ Payload Admin URL: ${payload.getAdminURL()}`)
    },
  })

  if (process.env.PAYLOAD_SEED === 'true') {
    await seed(payload)
    process.exit()
  }

  const nextApp = next({
    dev: process.env.NODE_ENV !== 'production',
  })

  const nextHandler = nextApp.getRequestHandler()

  await nextApp.prepare()

  app.use((req, res) => nextHandler(req, res))

  app.listen(PORT, () => {
    payload.logger.info(
      `🚀 Next.js App URL: ${process.env.PAYLOAD_PUBLIC_SERVER_URL || `http://localhost:${PORT}`}`,
    )
  })
}

start()
