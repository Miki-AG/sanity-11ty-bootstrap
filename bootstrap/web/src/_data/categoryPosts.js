// Map category slug -> array of posts in that category
import postsFn from './posts.js'

export default async function() {
  const posts = await postsFn()
  const bySlug = {}
  for (const p of posts) {
    const cats = Array.isArray(p.categories) ? p.categories : []
    for (const c of cats) {
      const slug = c?.slug
      if (!slug) continue
      if (!bySlug[slug]) bySlug[slug] = []
      bySlug[slug].push(p)
    }
  }
  // Optional: sort each list by date
  for (const k of Object.keys(bySlug)) {
    bySlug[k].sort((a, b) => {
      const ad = a.publishedAt || a._createdAt || ''
      const bd = b.publishedAt || b._createdAt || ''
      return ad < bd ? 1 : ad > bd ? -1 : 0
    })
  }
  return bySlug
}

