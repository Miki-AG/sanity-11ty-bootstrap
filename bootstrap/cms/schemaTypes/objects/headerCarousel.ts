import {defineField, defineType} from 'sanity'

export default defineType({
  name: 'headerCarousel',
  title: 'Header Carousel',
  type: 'object',
  fields: [
    defineField({
      name: 'contentSource',
      title: 'Content source',
      type: 'string',
      options: {
        list: [
          {title: 'Global header', value: 'global'},
          {title: 'Custom header', value: 'custom'},
        ],
        layout: 'radio',
      },
      initialValue: 'global',
    }),
    defineField({
      name: 'customHeader',
      title: 'Custom header',
      type: 'header',
      hidden: ({parent}) => parent?.contentSource !== 'custom',
    }),
    defineField({
      name: 'slides',
      title: 'Slides',
      type: 'array',
      of: [
        {
          type: 'object',
          name: 'headerCarouselSlide',
          title: 'Slide',
          fields: [
            defineField({
              name: 'image',
              title: 'Image',
              type: 'image',
              options: {hotspot: true},
              validation: r => r.required(),
            }),
            defineField({
              name: 'alt',
              title: 'Alt text',
              type: 'string',
            }),
            defineField({
              name: 'captionHeading',
              title: 'Caption heading',
              type: 'string',
            }),
            defineField({
              name: 'captionBody',
              title: 'Caption body',
              type: 'portableText',
            }),
          ],
          preview: {
            select: {
              media: 'image',
              title: 'captionHeading',
            },
            prepare({media, title}) {
              return {
                media,
                title: title || 'Slide',
              }
            },
          },
        },
      ],
      validation: r => r.min(1).error('Add at least one slide to the carousel.'),
    }),
  ],
  preview: {
    select: {slides: 'slides'},
    prepare({slides}) {
      const total = Array.isArray(slides) ? slides.length : 0
      return {
        title: 'Header Carousel',
        subtitle: total === 1 ? '1 slide' : `${total || 0} slides`,
      }
    },
  },
})
