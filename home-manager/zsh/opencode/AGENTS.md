# AGENTS

This document provides general guidelines for AI agents.

## Core Principles

- **Keep it simple and robust**: Avoid overengineering, YAGNI code, and unnecessary complexity
- **Understand before acting**: Study the existing patterns, conventions, and codebase structure
- **Think through edge cases**: Consider the implications and potential failure modes
- **Minimal changes**: Make the smallest possible changes to achieve the goal

### Generated Files - READ ONLY

**CRITICAL RULE**: Never edit, modify, or directly manipulate generated files. These files are automatically created by tools and processes; manual edits will be overwritten and can cause system instability.


### When using AI tools
- Research best practices using webfetch when uncertain
- Load relevant skills for specific technologies
- Consider architectural implications beyond immediate changes
- Ask for clarification if requirements seem incomplete or contradictory

## Error Handling

If you encounter issues:
1. Stop and analyze the root cause
2. Check if it's a generated file issue (most common)
3. Verify Nix paths and flake references
4. Check platform-specific constraints
5. Ask for guidance rather than guess

## Communication Style

- Be concise but thorough in explanations
- Focus on "why" not just "what"
- Provide context for architectural decisions
- Suggest alternatives when you see potential improvements
- Flag potential security or stability issues immediately
