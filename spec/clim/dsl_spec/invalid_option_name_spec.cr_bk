require "../dsl_spec"

macro invalid_option_name_spec(spec_class_name, spec_dsl_lines_cases)
  {% for spec_dsl_lines_case, index in spec_dsl_lines_cases %}
    {% class_name = (spec_class_name.stringify + index.stringify).id %}
    spec(
      spec_class_name: {{class_name}},
      spec_dsl_lines: {{spec_dsl_lines_case["lines"]}},
      spec_desc: "main command with invalid option name,",
      spec_cases: [
        {
          argv:              [] of String,
          exception_message: {{spec_dsl_lines_case["exception_message"]}},
        },
      ]
    )
  {% end %}
end

invalid_option_name_spec(
  spec_class_name: MainCommandWithEmptyShortOption,
  spec_dsl_lines_cases: [
    {
      lines: [
        "string \"\", \"--s1=S1\"",
      ],
      exception_message: "Empty short option.",
    },
    {
      lines: [
        "bool \"\", \"--b1=B1\"",
      ],
      exception_message: "Empty short option.",
    },
    {
      lines: [
        "array \"\", \"--a1=A1\"",
      ],
      exception_message: "Empty short option.",
    },
    {
      lines: [
        "string \"\"",
      ],
      exception_message: "Empty short option.",
    },
    {
      lines: [
        "bool \"\"",
      ],
      exception_message: "Empty short option.",
    },
    {
      lines: [
        "array \"\"",
      ],
      exception_message: "Empty short option.",
    },
    {
      lines: [
        "string \"-a A1\", \"--a1=A1\"",
        "array \"-a A2\", \"--a2=A2\"",
      ],
      exception_message: "Duplicate option. \"-a\"",
    },
    {
      lines: [
        "string \"-b B1\", \"--b1=B1\"",
        "bool \"-b\", \"--b2\"",
      ],
      exception_message: "Duplicate option. \"-b\"",
    },
    {
      lines: [
        "array \"-c C1\", \"--c1=C1\"",
        "bool \"-c\", \"--c2\"",
      ],
      exception_message: "Duplicate option. \"-c\"",
    },
    {
      lines: [
        "string \"-a A1\", \"--duplicate=A1\"",
        "array \"-b B1\", \"--duplicate=B1\"",
      ],
      exception_message: "Duplicate option. \"--duplicate\"",
    },
    {
      lines: [
        "string \"-a A1\", \"--duplicate=A1\"",
        "bool \"-b\", \"--duplicate\"",
      ],
      exception_message: "Duplicate option. \"--duplicate\"",
    },
    {
      lines: [
        "array \"-a A1\", \"--duplicate=A1\"",
        "bool \"-b\", \"--duplicate\"",
      ],
      exception_message: "Duplicate option. \"--duplicate\"",
    },
  ]
)
