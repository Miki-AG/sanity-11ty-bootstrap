import 'dotenv/config'
import {createClient} from '@sanity/client'

const projectId = process.env.SANITY_PROJECT_ID
const dataset   = process.env.SANITY_DATASET || 'production'
const apiVersion= process.env.SANITY_API_VERSION || '2025-01-01'

if (!projectId) console.warn('[warn] SANITY_PROJECT_ID missing in web/.env')

export const client = createClient({
  projectId,
  dataset,
  apiVersion,
  useCdn: process.env.ELEVENTY_ENV !== 'development',
})
