import groq from 'groq'
import {client} from './sanityClient.js'

const query = groq`*[_type=="landingPage"]{
  _id,title,titleAlign,"slug":slug.current,
  blocks[]{
    ...,
    _type=="imageWithCaption"=>{
      ...,
      "url":coalesce(image.asset->url,null)
    },
    _type=="quotes"=>{
      ...,
      "bgUrl":coalesce(coalesce(bgImage.asset->url,image.asset->url),null)
    },
    _type=="heroCover"=>{
      ...,
      "bgUrl":coalesce(bgImage.asset->url,null)
    },
    _type=="cardsGrid"=>{
      ...,
      cards[]{
        ...,
        "imageUrl":coalesce(image.asset->url,null)
      }
    },
    _type=="portfolio"=>{
      ...,
      items[]{
        ...,
        "imageUrl":coalesce(image.asset->url,null)
      }
    },
    _type=="imageGallery"=>{
      ...,
      images[]{
        ...,
        "imageUrl":coalesce(image.asset->url,null)
      }
    }
  }
} | order(title asc)`

export default async function() {
  const cfg = client.config()
  if (!cfg.projectId) return []
  try {
    return await client.fetch(query)
  } catch (e) {
    console.error('[sanity] fetch error:', e.message)
    return []
  }
}
