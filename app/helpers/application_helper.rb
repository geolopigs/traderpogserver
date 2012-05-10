module ApplicationHelper

  ##
  # Returns the language preferred by the user.
  ##
  def ApplicationHelper.preferred_language(accept_language_string, default_language="en-us")

    # parse Accept-Language
    if accept_language_string
      accepted = accept_language_string
    else
      accepted = default_language
    end
    accepted = accepted.to_s.split(",")
    accepted = accepted.map { |l| l.strip.split(";") }
    accepted = accepted.map { |l|
      if (l.size == 2)
        # quality present
        [ l[0].split("-")[0].downcase, l[1].sub(/^q=/, "").to_f ]
      else
        # no quality specified =&gt; quality == 1
        [ l[0].split("-")[0].downcase, 1.0 ]
      end
    }

    # sort by quality
    accepted.sort { |l1, l2| l1[1] <=> l2[1] }

    accepted.last[0]
  end

end
