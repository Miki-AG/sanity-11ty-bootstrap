import 'dotenv/config'
import {createClient} from '@sanity/client'
import fs from 'fs'
import path from 'path'

const client = createClient({
  projectId: process.env.SANITY_PROJECT_ID,
  dataset: process.env.SANITY_DATASET,
  useCdn: false, // `false` is required for real-time updates
  apiVersion: '2025-01-01',
})

const query = '*[_type == "landingPage"]'

console.log('[Sanity] Listening for content changes...')

const subscription = client.listen(query).subscribe(update => {
  const doc = update.result
  const type = update.type
  console.log(`[Sanity] Content event: ${type} for ${doc?.slug?.current || doc?._id}`)

  setTimeout(() => {
    // Touch a file that 11ty is watching to trigger a rebuild.
    const dataFile = path.join('src', '_data', 'pages.js')
    try {
      const time = new Date()
      fs.utimesSync(dataFile, time, time)
      console.log(`[11ty] Touched ${dataFile} to trigger rebuild.`)
    } catch (err) {
      console.error(`Error touching ${dataFile}:`, err)
    }
  }, 2000)
})

process.on('SIGINT', async () => {
  console.log('[Sanity] Stopping listener...')
  await subscription.unsubscribe()
  process.exit()
})
