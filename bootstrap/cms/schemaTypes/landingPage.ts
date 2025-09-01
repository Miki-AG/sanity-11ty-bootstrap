import {defineField, defineType} from 'sanity'

export default defineType({
  name: 'landingPage',
  title: 'Landing Page',
  type: 'document',
  fields: [
    defineField({ name: 'title', type: 'string', validation: r => r.required() }),
    defineField({ name: 'slug', type: 'slug', options: { source: 'title', maxLength: 96 }, validation: r => r.required() }),
    defineField({
      name: 'blocks',
      title: 'Blocks',
      type: 'array',
      of: [
        {type: 'heroCover'},
        {type: 'featuresGrid'},
        {type: 'cardsGrid'},
        {type: 'pricingTable'},
        {type: 'faqAccordion'},
        {type: 'ctaBanner'},
        {type: 'imageWithCaption'},
        {type: 'twoColumnText'},
        {type: 'quotes'},
        {type: 'portfolio'},
        {type: 'richText'},
        {type: 'imageGallery'}
      ]
    })
  ]
})
