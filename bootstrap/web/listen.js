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

// Listen for changes to content that affects the site output
const query = '*[_type in ["landingPage","siteSettings"]]'

console.log('[Sanity] Listening for content changes...')

const subscription = client.listen(query).subscribe(update => {
  const doc = update.result
  const type = update.type
  console.log(`[Sanity] Content event: ${type} for ${doc?.slug?.current || doc?._id}`)

  setTimeout(() => {
    // Touch data files that Eleventy watches to trigger a rebuild.
    const files = [
      path.join('src', '_data', 'pages.js'),
      path.join('src', '_data', 'globals.js'),
    ]
    const time = new Date()
    for (const dataFile of files) {
      try {
        fs.utimesSync(dataFile, time, time)
        console.log(`[11ty] Touched ${dataFile} to trigger rebuild.`)
      } catch (err) {
        console.error(`Error touching ${dataFile}:`, err)
      }
    }
  }, 2000)
})

process.on('SIGINT', async () => {
  console.log('[Sanity] Stopping listener...')
  await subscription.unsubscribe()
  process.exit()
})
