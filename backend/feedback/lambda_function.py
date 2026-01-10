"""
Ndmr Feedback Lambda - Posts feedback to Slack channel #ndmr
"""

import json
import os
import urllib.request
import urllib.error
from datetime import datetime


SLACK_WEBHOOK_URL = os.environ.get('SLACK_WEBHOOK_URL')

# CORS headers for browser requests
CORS_HEADERS = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
}


def lambda_handler(event, context):
    """Handle incoming feedback requests."""

    # Debug logging
    print(f"Event: {json.dumps(event)}")

    # Get HTTP method (supports both v1.0 and v2.0 payload formats)
    http_method = event.get('httpMethod') or event.get('requestContext', {}).get('http', {}).get('method', '')

    # Handle CORS preflight
    if http_method == 'OPTIONS':
        return {
            'statusCode': 200,
            'headers': CORS_HEADERS,
            'body': ''
        }

    try:
        # Parse request body
        body = event.get('body', '{}')
        if isinstance(body, str):
            body = json.loads(body)

        # Extract feedback data
        feedback_type = body.get('type', 'feedback')  # feedback, bug, feature, contact
        name = body.get('name', 'Anonymous')
        email = body.get('email', '')
        callsign = body.get('callsign', '')
        message = body.get('message', '')
        source = body.get('source', 'website')  # website or app

        # Validate required fields
        if not message:
            return {
                'statusCode': 400,
                'headers': CORS_HEADERS,
                'body': json.dumps({'error': 'Message is required'})
            }

        # Build Slack message
        slack_message = build_slack_message(
            feedback_type=feedback_type,
            name=name,
            email=email,
            callsign=callsign,
            message=message,
            source=source
        )

        # Post to Slack
        success = post_to_slack(slack_message)

        if success:
            return {
                'statusCode': 200,
                'headers': CORS_HEADERS,
                'body': json.dumps({'success': True, 'message': 'Feedback sent successfully'})
            }
        else:
            return {
                'statusCode': 500,
                'headers': CORS_HEADERS,
                'body': json.dumps({'error': 'Failed to send feedback'})
            }

    except json.JSONDecodeError:
        return {
            'statusCode': 400,
            'headers': CORS_HEADERS,
            'body': json.dumps({'error': 'Invalid JSON'})
        }
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'headers': CORS_HEADERS,
            'body': json.dumps({'error': 'Internal server error'})
        }


def build_slack_message(feedback_type, name, email, callsign, message, source):
    """Build a formatted Slack message with blocks."""

    # Emoji and color based on type
    type_config = {
        'feedback': {'emoji': ':speech_balloon:', 'color': '#36a64f', 'title': 'New Feedback'},
        'bug': {'emoji': ':bug:', 'color': '#ff0000', 'title': 'Bug Report'},
        'feature': {'emoji': ':bulb:', 'color': '#ffcc00', 'title': 'Feature Request'},
        'contact': {'emoji': ':email:', 'color': '#0066ff', 'title': 'Contact Message'},
    }

    config = type_config.get(feedback_type, type_config['feedback'])

    # Build user info string
    user_info_parts = [f"*{name}*"]
    if callsign:
        user_info_parts.append(f"({callsign})")
    if email:
        user_info_parts.append(f"- {email}")
    user_info = ' '.join(user_info_parts)

    # Build Slack message with attachments
    slack_message = {
        'text': f"{config['emoji']} {config['title']} from Ndmr",
        'attachments': [
            {
                'color': config['color'],
                'blocks': [
                    {
                        'type': 'section',
                        'text': {
                            'type': 'mrkdwn',
                            'text': f"{config['emoji']} *{config['title']}*"
                        }
                    },
                    {
                        'type': 'section',
                        'fields': [
                            {
                                'type': 'mrkdwn',
                                'text': f"*From:*\n{user_info}"
                            },
                            {
                                'type': 'mrkdwn',
                                'text': f"*Source:*\n{source.capitalize()}"
                            }
                        ]
                    },
                    {
                        'type': 'section',
                        'text': {
                            'type': 'mrkdwn',
                            'text': f"*Message:*\n{message}"
                        }
                    },
                    {
                        'type': 'context',
                        'elements': [
                            {
                                'type': 'mrkdwn',
                                'text': f":clock1: {datetime.utcnow().strftime('%Y-%m-%d %H:%M UTC')}"
                            }
                        ]
                    }
                ]
            }
        ]
    }

    return slack_message


def post_to_slack(message):
    """Post message to Slack webhook."""

    if not SLACK_WEBHOOK_URL:
        print("Error: SLACK_WEBHOOK_URL not configured")
        return False

    try:
        data = json.dumps(message).encode('utf-8')
        req = urllib.request.Request(
            SLACK_WEBHOOK_URL,
            data=data,
            headers={'Content-Type': 'application/json'}
        )

        with urllib.request.urlopen(req, timeout=10) as response:
            return response.status == 200

    except urllib.error.URLError as e:
        print(f"Slack webhook error: {str(e)}")
        return False
    except Exception as e:
        print(f"Error posting to Slack: {str(e)}")
        return False
