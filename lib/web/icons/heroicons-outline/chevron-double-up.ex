defmodule Iconify.HeroiconsOutline.ChevronDoubleUp do
  use Phoenix.Component
  def render(assigns) do
    ~H"""
    <svg xmlns="http://www.w3.org/2000/svg" aria-hidden="true" role="img" class={@class} viewBox="0 0 24 24" aria-hidden="true"><path fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m5 11l7-7l7 7M5 19l7-7l7 7"/></svg>
    """
  end
end
