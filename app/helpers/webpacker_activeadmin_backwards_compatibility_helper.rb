# This module provides backward compatiblity with webpacker for activeadmin
# Once activeadmin supports vite directly, this can be removed.
module WebpackerActiveadminBackwardsCompatibilityHelper
  def stylesheet_pack_tag(style, **options)
    # noop as the stylesheet comes from the vite build via vite_javascript_tag
  end

  def javascript_pack_tag(script, **options)
    vite_javascript_tag(script, **options)
  end
end
