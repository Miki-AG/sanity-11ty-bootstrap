import {toHtml as ptToHtml} from './src/_data/portableText.js'

export default function(eleventyConfig) {
  eleventyConfig.addPassthroughCopy({"src/assets":"assets"});
  eleventyConfig.addFilter('pt', (value) => ptToHtml(value))
  eleventyConfig.addFilter('dateFmt', (value, locale = 'en-US', options) => {
    if (!value) return ''
    try {
      const d = new Date(value)
      return d.toLocaleDateString(locale, options || { year: 'numeric', month: 'short', day: 'numeric' })
    } catch (e) {
      return String(value)
    }
  })
  return {
    dir:{ input:"src", includes:"_includes", data:"_data", output:"_site" },
    htmlTemplateEngine:"njk",
    markdownTemplateEngine:"njk",
    templateFormats:["njk","md","html","11ty.js"]
  };
}
