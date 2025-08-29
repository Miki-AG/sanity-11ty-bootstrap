import groq from 'groq'
import {client} from './sanityClient.js'

const query = groq`*[_type=="siteSettings"][0]{
  siteTitle,
  header
}`

export default async function() {
  const cfg = client.config()
  if (!cfg.projectId) return {}
  try {
    const data = await client.fetch(query)
    return data || {}
  } catch (e) {
    console.error('[sanity] globals fetch error:', e.message)
    return {}
  }
}

