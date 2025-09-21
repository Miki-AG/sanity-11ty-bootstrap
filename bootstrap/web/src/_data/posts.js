import groq from 'groq'
import {client} from './sanityClient.js'

// Fetch blog posts with resolved fields and image URLs inside blocks
const query = groq`*[_type=="post" && defined(slug.current)]{
  _id,
  title,
  "slug": slug.current,
  publishedAt,
  excerpt,
  "coverUrl": coalesce(coverImage.asset->url, null),
  author->{ name, "slug": slug.current, "imageUrl": coalesce(image.asset->url, null) },
  categories[]->{ title, "slug": slug.current },
  blocks[]{
    ...,
    _type=="imageWithCaption"=>{ ..., "url":coalesce(image.asset->url,null) },
    _type=="quotes"=>{ ..., "bgUrl":coalesce(coalesce(bgImage.asset->url,image.asset->url),null) },
    _type=="heroCover"=>{ ..., "bgUrl":coalesce(bgImage.asset->url,null) },
    _type=="headerBlock"=>{ ..., "heroImageUrl":coalesce(heroImage.asset->url,null), "heroImageAlt":coalesce(heroImage.alt,null) },
    _type=="headerCarousel"=>{
      ...,
      slides[]{
        ...,
        "imageUrl":coalesce(image.asset->url,null),
        "imageAlt":coalesce(alt,null)
      }
    },
    _type=="cardsGrid"=>{ ..., cards[]{ ..., "imageUrl":coalesce(image.asset->url,null) } },
    _type=="portfolio"=>{ ..., items[]{ ..., "imageUrl":coalesce(image.asset->url,null) } },
    _type=="imageGallery"=>{ ..., images[]{ ..., "imageUrl":coalesce(image.asset->url,null) } },
    _type=="adjustableImage"=>{ ..., "imageUrl":coalesce(image.asset->url,null) }
  }
} | order(coalesce(publishedAt, _createdAt) desc)`

export default async function() {
  const cfg = client.config()
  if (!cfg.projectId) return []
  try {
    return await client.fetch(query)
  } catch (e) {
    console.error('[sanity] posts fetch error:', e.message)
    return []
  }
}
